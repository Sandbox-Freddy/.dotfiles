# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  hostVariables,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = hostVariables.host; # Define your hostname.

  # Modules
  modules.gui.gnome = {
    favoriteApps = [
      "org.gnome.Console.desktop"
      "firefox.desktop"
      "google-chrome.desktop"
      "dev.zed.Zed.desktop"
      "steam.desktop"
      "discord-ptb.desktop"
      "org.gnome.Nautilus.desktop"
    ];
  };

  users.users.${hostVariables.username} = {
    extraGroups = ["vboxusers"];
  };

  environment.systemPackages = with pkgs; [
    asunder

    (unstable.google-chrome.override {
      commandLineArgs = [
        "--ozone-platform=wayland"
        "--disable-gtk-ime"
        "--disable-features=PdfOopif"
      ];
    })
    cifs-utils
    ffmpeg
    lame
    unstable.lmstudio
    pinta
    sbctl
    unstable.space-cadet-pinball
  ];

  home-manager.users.${hostVariables.username} = {
    home.packages = with pkgs; [
      thunderbird
      keepassxc
      losslesscut-bin
      yubioath-flutter
    ];
  };

  #Yubikey
  services.pcscd.enable = true;

  services.udev.extraRules = ''
    ATTRS{idVendor}=="044f", ATTRS{idProduct}=="b668", MODE="0660", GROUP="plugdev"
  '';
  system.stateVersion = hostVariables.stateVersion;

  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  # virtualisation.libvirtd.enable = false;
  # boot.blacklistedKernelModules = ["kvm-intel" "kvm-amd" "xpad"];
}
