# Common settings shared by every host. Host-specific bits live in
# hosts/<host>/configuration.nix, feature toggles in hosts/<host>/variables.nix.
{
  pkgs,
  lib,
  hostVariables,
  ...
}: {
  imports = [
    ./home.nix
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
