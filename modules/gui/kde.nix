{
  pkgs,
  lib,
  config,
  ...
}: {
  options.modules.gui.kde = {
    enable = lib.mkEnableOption "kde";
  };
  config = lib.mkIf config.modules.gui.kde.enable {
    hardware.bluetooth.enable = true;
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      konsole
      oxygen
    ];
  };
}
