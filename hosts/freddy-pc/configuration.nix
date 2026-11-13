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
      pinta
      thunderbird
      unstable.space-cadet-pinball
    ];
  };

  # uaccess has to be tagged before systemd's 73-seat-late.rules consumes it,
  # and services.udev.extraRules writes 99-local.rules — hence the own package.
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "thrustmaster-udev-rules";
      destination = "/etc/udev/rules.d/60-thrustmaster.rules";
      text = ''
        ATTRS{idVendor}=="044f", ATTRS{idProduct}=="b668", MODE="0660", TAG+="uaccess"
      '';
    })
  ];

  # Kept disabled on purpose. Re-enabling needs the group line too: the
  # virtualbox module creates vboxusers but does not put anyone in it.
  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  # virtualisation.libvirtd.enable = false;
  # boot.blacklistedKernelModules = ["kvm-intel" "kvm-amd" "xpad"];
  # users.users.${hostVariables.username}.extraGroups = ["vboxusers"];
}
