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
    unstable.bruno
    unstable.dbeaver-bin
    drawio
    unstable.jetbrains.idea
    keepassxc
    unstable.microsoft-edge
    neofetch
    pinta
    yubioath-flutter
  ];

  #Yubikey
  services.pcscd.enable = true;

  system.stateVersion = hostVariables.stateVersion; # Did you read the comment?

  zramSwap.enable = true;
}
