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
  modules.software.discord.enable = hostVariables.modules.discord;
  modules.software.displaylink.enable = hostVariables.modules.display-link;
  modules.software.idea-ultimate.enable = hostVariables.modules.idea-ultimate;
  modules.software.webstorm.enable = hostVariables.modules.webstorm;
  modules.software.lutris.enable = hostVariables.modules.lutris;
  modules.software.steam.enable = hostVariables.modules.steam;
  modules.software.vscode.enable = hostVariables.modules.vscode;
  modules.gui.gnome.enable = hostVariables.modules.gnome;
  modules.gui.kde.enable = hostVariables.modules.kde;
  modules.driver.nvidia.enable = hostVariables.modules.driver.nvidia;
  modules.driver.amdgpu.enable = hostVariables.modules.driver.amdgpu;

  environment.systemPackages = with pkgs; [
    alejandra
  ];

  # Printer
  services.printing.enable = hostVariables.printer;
  services.avahi = {
    enable = hostVariables.printer;
    nssmdns4 = hostVariables.printer;
    openFirewall = hostVariables.printer;
  };

  programs.nh = {
    enable = true;
    flake = "/home/${hostVariables.username}/.dotfiles";
  };
}
