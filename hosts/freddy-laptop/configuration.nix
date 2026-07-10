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

  # Enable networking
  networking.networkmanager = {
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${hostVariables.username} = {
    extraGroups = ["vboxusers"];
  };

  # Install direnv
  programs.direnv.enable = true;

  # Install firefox.
  programs.firefox = {
    enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
    keepassxc
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
  system.stateVersion = hostVariables.stateVersion; # Did you read the comment?

  zramSwap.enable = true;

  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  # virtualisation.libvirtd.enable = false;
  # boot.blacklistedKernelModules = ["kvm-intel" "kvm-amd" "xpad"];
}
