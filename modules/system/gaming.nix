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
      package = pkgs.steam.override {
        extraPkgs = pkgs: [pkgs.attr pkgs.pipewire pkgs.pkgsi686Linux.pipewire];
      };
    };
  };
}
