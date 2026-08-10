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

    boot.plymouth.theme = "spinner"; # oder "spinner", "fade-in", "text", "tribar" …

    boot.initrd.systemd.enable = true;
  };
}
