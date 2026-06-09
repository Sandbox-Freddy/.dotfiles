{
  pkgs,
  config,
  lib,
  ...
}: {
  options.modules.software.gaming = {
    enable = lib.mkEnableOption "gaming";
  };

  config = lib.mkIf config.modules.software.gaming.enable {
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
      package = pkgs.steam.override {
        extraPkgs = pkgs: [pkgs.pipewire pkgs.pkgsi686Linux.pipewire];
      };
    };
  };
}
