# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  hostVariables,
  config,
  ...
}: {
  imports = [
    ./home.nix
  ];
  # Modules
  modules.console.fish.enable = hostVariables.modules.console.fish;
  modules.driver.amdgpu.enable = hostVariables.modules.driver.amdgpu;
  modules.driver.nvidia.enable = hostVariables.modules.driver.nvidia;
  modules.gui.gnome.enable = hostVariables.modules.gui.gnome;
  modules.printer.printer.enable = hostVariables.modules.printer.printer;
  modules.printer.sane.enable = hostVariables.modules.printer.sane;
  modules.printer.scanbutton.enable = hostVariables.modules.printer.scanbutton;
  modules.software.displaylink.enable = hostVariables.modules.software.display-link;
  modules.software.docker.enable = hostVariables.modules.software.docker;
  modules.software.flatpak.enable = hostVariables.modules.software.flatpak;
  modules.software.git.enable = hostVariables.modules.software.git;
  modules.software.python.enable = hostVariables.modules.software.python;
  modules.software.easyeffects.enable = hostVariables.modules.software.easyeffects;
  modules.software.zed.enable = hostVariables.modules.software.zed;
  modules.system.bootanimation.enable = hostVariables.modules.systemSettings.bootanimation;
  modules.software.gaming.enable = hostVariables.modules.software.gaming;

  # Common Desktop / System Settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [networkmanager-openvpn];
  };
  time.timeZone = "Europe/Berlin";

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };
  console.keyMap = "de";

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.support32Bit = true;
  };
  security.rtkit.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  users.users.${hostVariables.username} = {
    isNormalUser = true;
    description = hostVariables.description;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    alejandra
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  # Common programs / settings across all hosts
  programs.direnv.enable = true;
  programs.firefox.enable = true;
  zramSwap.enable = true;

  programs.nh = {
    enable = true;
    flake = "${config.users.users.${hostVariables.username}.home}/.dotfiles";
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    flake = "/home/${hostVariables.username}/.dotfiles";
    operation = "switch";
  };
}
