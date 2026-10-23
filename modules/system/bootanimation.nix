{
  config,
  lib,
  ...
}: {
  options.modules.system.bootanimation = {
    enable = lib.mkEnableOption "bootanimation";
  };

  config = lib.mkIf config.modules.system.bootanimation.enable {
    boot.plymouth.enable = true;
    boot.plymouth.theme = "spinner";
    boot.initrd.systemd.enable = true;
  };
}
