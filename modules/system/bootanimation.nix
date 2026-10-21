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

    # themePackages is empty, so the choices are the ones the plymouth
    # package ships: bgrt (the NixOS default), details, fade-in, glow,
    # script, solar, spinfinity, text, tribar.
    boot.plymouth.theme = "spinner";

    boot.initrd.systemd.enable = true;
  };
}
