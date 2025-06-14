{
  pkgs,
  config,
  lib,
  ...
}: {
  options.modules.system.gaming = {
    enable = lib.mkEnableOption "gaming";
  };

  config = lib.mkIf config.modules.system.gaming.enable {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
      ];

    programs.gamemode.enable = true;
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      package = pkgs.unstable.steam.override {
        extraPkgs = pkgs: [pkgs.attr pkgs.pipewire pkgs.pkgsi686Linux.pipewire];
      };
    };

    environment.systemPackages = with pkgs; [
      protonup-qt
      dxvk
      vkd3d-proton
      bottles
      mangohud
      lutris
      (lutris.override {
        extraLibraries = pkgs: [
          # List library dependencies here
        ];
      })
      (lutris.override {
        extraPkgs = pkgs: [
          # List package dependencies here
        ];
      })
    ];

    environment.variables = {
      MANGOHUD = "0";
    };
  };
}
