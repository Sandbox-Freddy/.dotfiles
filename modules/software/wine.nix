{
  pkgs,
  lib,
  config,
  hostVariables,
  ...
}: {
  options.modules.software.wine = {
    enable = lib.mkEnableOption "wine";
  };
  config = lib.mkIf config.modules.software.wine.enable {
    environment.systemPackages = with pkgs; [
      wineWowPackages.stable
      wineWowPackages.staging
      winetricks
      wineWowPackages.waylandFull
    ];
  };
}
