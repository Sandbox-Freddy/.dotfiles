{
  hostVariables,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  modules.gui.gnome = {
    favoriteApps = [
      "org.gnome.Console.desktop"
      "firefox.desktop"
      "google-chrome.desktop"
      "dev.zed.Zed.desktop"
      "SourceGit.desktop"
      "steam.desktop"
      "discord-ptb.desktop"
      "org.gnome.Nautilus.desktop"
    ];
    lockEnabled = false;
    lockOnSuspend = false;
  };

  users.users.${hostVariables.username} = {
    extraGroups = ["vboxusers"];
  };

  environment.systemPackages = with pkgs; [
    cifs-utils
    sbctl
  ];

  home-manager.users.${hostVariables.username} = {
    home.packages = with pkgs; [
      asunder
      chrome-wayland
      ffmpeg
      github-cli
      keepassxc
      lame
      librewolf
      losslesscut-bin
      opencode
      pinta
      thunderbird
      unstable.space-cadet-pinball
    ];
  };

  services.udev.extraRules = ''
    ATTRS{idVendor}=="044f", ATTRS{idProduct}=="b668", MODE="0660", GROUP="plugdev"
  '';

  # Kept disabled on purpose; the vboxusers group above exists for re-enabling.
  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  # virtualisation.libvirtd.enable = false;
  # boot.blacklistedKernelModules = ["kvm-intel" "kvm-amd" "xpad"];
}
