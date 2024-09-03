{
  config,
  pkgs,
  lib,
  ...
}: {
  options.modules.software.displaylink = {
    enable = lib.mkEnableOption "displaylink";
  };

  config = lib.mkIf config.modules.software.displaylink.enable {
    services.xserver.videoDrivers = ["displaylink" "modesetting" "amdgpu"];
    services.xserver.displayManager.sessionCommands = ''
      ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
    '';
  };
}
