{
  config,
  lib,
  hostVariables,
  pkgs,
  ...
}: {
  options.modules.system.virtualization = {
    enable = lib.mkEnableOption "virtualization";
  };

  config = lib.mkIf config.modules.system.virtualization.enable {
    boot.extraModprobeConfig = "options kvm_intel nested=1";

    programs.dconf.enable = true;

    # Add user to libvirtd group
    users.users.${hostVariables.username}.extraGroups = ["libvirtd"];

    # Install necessary packages
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      win-virtio
      win-spice
      adwaita-icon-theme
    ];

    # Manage the virtualisation services
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [pkgs.OVMFFull.fd];
        };
      };
      spiceUSBRedirection.enable = true;
    };
    services.spice-vdagentd.enable = true;
  };
}
