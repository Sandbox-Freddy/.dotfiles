# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  hostVariables,
  pkgs,
  ...
}:
{
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
      "dev.zed.Zed.desktop"
      "chrome-cifhbcnohmdccbgoicgdjpfamggdegmo-Default.desktop"
      "chrome-faolnafnngnfdaknnbpnkhgohbobgegn-Default.desktop"
      "google-chrome.desktop"
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
    pinta
  ];

  home-manager.users.${hostVariables.username} = {
    home.packages = with pkgs; [
      awscli2
      aisleriot
      unstable.bruno
      claude-code
      unstable.dbeaver-bin
      drawio
      granted
      (unstable.google-chrome.override {
        commandLineArgs = [
          "--ozone-platform=wayland"
          "--disable-gtk-ime"
          "--disable-features=PdfOopif"
        ];
      })
      jq
      keepassxc
      nodejs_24
      obsidian
      unstable.lmstudio
      yubioath-flutter
      xournalpp
      zed-editor
    ];
  };

  #Yubikey
  services.pcscd.enable = true;

  system.stateVersion = hostVariables.stateVersion;

  zramSwap.enable = true;

  environment.shellAliases = {
    awsssologin = "aws sso login --no-browser --sso-session";
  };
}
