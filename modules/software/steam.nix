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
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;

    environment.systemPackages = with pkgs; [
      mangohud
    ];

    programs.gamemode.enable = true;
  };
}
