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
      "bruno.desktop"
      "idea.desktop"
      "brave-browser.desktop"
      "brave-cifhbcnohmdccbgoicgdjpfamggdegmo-Default.desktop"
      "microsoft-edge.desktop"
      "org.keepassxc.KeePassXC.desktop"
      "com.yubico.yubioath.desktop"
      "org.gnome.Nautilus.desktop"
      "org.gnome.TextEditor.desktop"
      "firefox.desktop"
    ];
    idleDelay = 300;
    leftHanded = false;
  };

  modules.software.git = {
    includes = [
      {
        path = "~/Dev/.gitconfig";
        condition = "gitdir:~/Dev/";
      }
    ];
  };

  # Enable networking
  networking.networkmanager = {
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
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
    neofetch
    pinta
  ];

  # Wayland/GPU fixes for Chromium-based apps
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  home-manager.users.${hostVariables.username} = {
    home.packages = with pkgs; [
      unstable.bruno
      unstable.brave
      claude-code
      unstable.dbeaver-bin
      drawio
      unstable.jetbrains.idea
      keepassxc
      unstable.lmstudio
      nodejs_24
      yubioath-flutter
    ];

    # GPU/Wayland flags for Chromium-based browsers
    xdg.configFile."brave-flags.conf".text = ''
      --enable-features=UseOzonePlatform,VaapiVideoDecoder,VaapiVideoEncoder
      --ozone-platform=wayland
      --enable-gpu-rasterization
      --enable-zero-copy
    '';

    xdg.configFile."electron-flags.conf".text = ''
      --enable-features=UseOzonePlatform
      --ozone-platform=wayland
    '';
  };

  #Yubikey
  services.pcscd.enable = true;

  system.stateVersion = hostVariables.stateVersion; # Did you read the comment?

  zramSwap.enable = true;
}
