{
  config,
  lib,
  ...
}: {
  options.modules.software.displaylink = {
    enable = lib.mkEnableOption "displaylink";
  };

  config = lib.mkIf config.modules.software.displaylink.enable {
    services.xserver.videoDrivers = ["displaylink" "modesetting" "amdgpu"];
    systemd.services.dlm.wantedBy = ["multi-user.target"];
  };
}
