{
  pkgs,
  lib,
  config,
  hostVariables,
  ...
}: {
  options.modules.software.steam = {
    enable = lib.mkEnableOption "steam";
  };
  config = lib.mkIf config.modules.software.steam.enable {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
      ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      package = pkgs.unstable.steam.override {
        extraPkgs = pkgs: [pkgs.attr pkgs.pipewire pkgs.pkgsi686Linux.pipewire];
      };
      gamescopeSession.enable = true;
    };
    programs.gamemode.enable = true;
  };
}
