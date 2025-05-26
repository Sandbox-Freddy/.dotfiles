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
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        ovmf.enable = true;
        swtpm.enable = true;
        runAsRoot = true;
      };
    };

    programs.virt-manager.enable = true;

    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice-gtk
      qemu_kvm
      usbutils
    ];

    users.users.${hostVariables.username} = {
      isNormalUser = true;
      extraGroups = ["wheel" "libvirt" "kvm" "input"];
    };

    security.polkit.enable = true;
    environment.etc."polkit-1/rules.d/50-libvirt-usb.rules".text = ''
      polkit.addRule(function(action, subject) {
        if (
          action.id == "org.spice-space.lowlevelusbaccess" &&
          subject.isInGroup("libvirt")
        ) {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
