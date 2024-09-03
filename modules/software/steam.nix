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
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      package = pkgs.unstable.steam.override {
        extraPkgs = pkgs: [pkgs.attr];
      };
      gamescopeSession.enable = true;
    };
    programs.gamemode.enable = true;
  };
}
