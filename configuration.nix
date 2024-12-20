# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  hostVariables,
  ...
}: {
  # Modules
  modules.software.docker.enable = hostVariables.modules.docker;
  modules.software.git.enable = hostVariables.modules.git;
  modules.software.flatpak.enable = hostVariables.modules.flatpak;
  modules.software.displaylink.enable = hostVariables.modules.display-link;
  modules.software.jetbrains.enable = hostVariables.modules.jetbrains;
  modules.software.lutris.enable = hostVariables.modules.lutris;
  modules.software.steam.enable = hostVariables.modules.steam;
  modules.software.vscode.enable = hostVariables.modules.vscode;
  modules.gui.gnome.enable = hostVariables.modules.gnome;
  modules.gui.kde.enable = hostVariables.modules.kde;
  modules.driver.nvidia.enable = hostVariables.modules.driver.nvidia;
  modules.driver.amdgpu.enable = hostVariables.modules.driver.amdgpu;

  services.printing.enable = hostVariables.printer;

  environment.systemPackages = with pkgs; [
    alejandra
  ];
}
