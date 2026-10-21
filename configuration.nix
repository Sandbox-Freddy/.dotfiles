# Common settings shared by every host. Host-specific bits live in
# hosts/<host>/configuration.nix, feature toggles in hosts/<host>/variables.nix.
{
  pkgs,
  lib,
  hostVariables,
  ...
}: let
  # Modules that are deliberately ungated common settings rather than features,
  # and therefore have no toggle. Everything else must have one.
  ungatedModules = [
    "console/aliases.nix"
    "system/flakes.nix"
    "system/i18n.nix"
    "system/keybindings.nix"
  ];

  # The gated modules actually on disk, as {category = ["name" ...];}. A module
  # is either `<category>/<name>.nix` or `<category>/<name>/<name>.nix` when it
  # ships data files alongside. A subdirectory without that inner `.nix` is a
  # plain data directory owned by some other module (console/oh-my-posh), not a
  # module itself.
  gatedModules = let
    categories = lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./modules);

    namesIn = category: let
      entries = builtins.readDir (./modules + "/${category}");
      isNixFile = name: type: type == "regular" && lib.hasSuffix ".nix" name;
      fromFiles =
        lib.mapAttrsToList
        (name: _: {
          toggle = lib.removeSuffix ".nix" name;
          path = "${category}/${name}";
        })
        (lib.filterAttrs isNixFile entries);
      fromDirs =
        lib.mapAttrsToList
        (name: _: {
          toggle = name;
          path = "${category}/${name}/${name}.nix";
        })
        (lib.filterAttrs
          (name: type:
            type
            == "directory"
            && builtins.pathExists (./modules + "/${category}/${name}/${name}.nix"))
          entries);
    in
      map (m: m.toggle)
      (builtins.filter (m: !(builtins.elem m.path ungatedModules)) (fromFiles ++ fromDirs));
  in
    lib.mapAttrs (category: _: namesIn category) categories;

  togglesIn = category: lib.attrNames (hostVariables.modules.${category} or {});

  # A module without a toggle can never be switched on, and nothing complains —
  # so turn it into a build failure. The reverse case (a toggle with no module)
  # needs no check here: the module system already throws on an undeclared
  # `modules.<category>.<name>` option, and even suggests the right name.
  modulesWithoutToggle = lib.concatLists (lib.mapAttrsToList
    (category: names: map (n: "${category}.${n}") (lib.subtractLists (togglesIn category) names))
    gatedModules);
in {
  imports = [
    ./home.nix
  ];

  assertions = [
    {
      assertion = modulesWithoutToggle == [];
      message = ''
        These modules have no toggle in variables/defaultVariables.nix and can
        therefore never be enabled: ${lib.concatStringsSep ", " modulesWithoutToggle}

        Add a boolean of the same name under `modules.<category>`, or list the
        module in `ungatedModules` in configuration.nix if it is meant to be a
        common setting rather than a feature.
      '';
    }
  ];

  # Feature modules: every `hostVariables.modules.<category>.<name>` boolean maps
  # onto `modules.<category>.<name>.enable`, so names must match the module paths.
  modules = lib.mapAttrs (_: lib.mapAttrs (_: enable: {inherit enable;})) hostVariables.modules;

  # Common Desktop / System Settings
  networking.hostName = hostVariables.host;
  system.stateVersion = hostVariables.stateVersion;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [networkmanager-openvpn];
  };
  time.timeZone = "Europe/Berlin";

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };
  console.keyMap = "de";

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.support32Bit = true;
  };
  security.rtkit.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  users.users.${hostVariables.username} = {
    isNormalUser = true;
    description = hostVariables.description;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    alejandra
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  # Common programs / settings across all hosts
  programs.firefox.enable = true;
  zramSwap.enable = true;

  programs.nh = {
    enable = true;
    flake = hostVariables.dotfilesDir;
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    flake = hostVariables.dotfilesDir;
    operation = "switch";
  };
}
