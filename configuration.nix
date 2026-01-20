# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  hostVariables,
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
  modules.software.displaylink.enable = hostVariables.modules.software.display-link;
  modules.software.docker.enable = hostVariables.modules.software.docker;
  modules.software.flatpak.enable = hostVariables.modules.software.flatpak;
  modules.software.git.enable = hostVariables.modules.software.git;
  modules.software.noisetorch.enable = hostVariables.modules.software.noisetorch;
  modules.software.wine.enable = hostVariables.modules.software.wine;
  modules.software.ollama.enable = hostVariables.modules.software.ollama;
  modules.system.bootanimation.enable = hostVariables.modules.systemSettings.bootanimation;
  modules.system.gaming.enable = hostVariables.modules.systemSettings.gaming;

  # Common Desktop / System Settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = hostVariables.location;

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };
  console.keyMap = "de";

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  users.users.${hostVariables.username} = {
    isNormalUser = true;
    description = "${hostVariables.description}";
    extraGroups = ["networkmanager" "wheel"];
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

  programs.nh = {
    enable = true;
    flake = "/home/${hostVariables.username}/.dotfiles";
  };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
}
