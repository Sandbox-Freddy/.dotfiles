# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  hostVariables,
  ...
}: {
  # Modules
  modules.software.android-studio.enable = hostVariables.modules.android-studio;
  modules.software.docker.enable = hostVariables.modules.docker;
  modules.software.git.enable = hostVariables.modules.git;
  modules.software.flatpak.enable = hostVariables.modules.flatpak;
  modules.software.discord.enable = hostVariables.modules.discord;
  modules.software.displaylink.enable = hostVariables.modules.display-link;
  modules.software.idea-ultimate.enable = hostVariables.modules.idea-ultimate;
  modules.software.noisetorch.enable = hostVariables.modules.noisetorch;
  modules.software.vscode.enable = hostVariables.modules.vscode;
  modules.software.webstorm.enable = hostVariables.modules.webstorm;
  modules.software.wine.enable = hostVariables.modules.wine;
  modules.gui.gnome.enable = hostVariables.modules.gnome;
  modules.gui.kde.enable = hostVariables.modules.kde;
  modules.gui.hyperland.enable = hostVariables.modules.hyperland;
  modules.driver.nvidia.enable = hostVariables.modules.driver.nvidia;
  modules.driver.amdgpu.enable = hostVariables.modules.driver.amdgpu;
  modules.system.bootanimation.enable = hostVariables.systemSettings.bootanimation;
  modules.system.gaming.enable = hostVariables.systemSettings.gaming;
  modules.system.printer.enable = hostVariables.systemSettings.printer;
  modules.system.virtualization.enable = hostVariables.systemSettings.virtualization;

  environment.systemPackages = with pkgs; [
    alejandra
  ];

  programs.nh = {
    enable = true;
    flake = "/home/${hostVariables.username}/.dotfiles";
  };
}
