{
  pkgs,
  lib,
  config,
  nix-vscode-extensions,
  ...
}: {
  options.modules.software.flatpak = {
    enable = lib.mkEnableOption "flatpak";
  };

  config = lib.mkIf config.modules.software.flatpak.enable {
    services.flatpak.enable = true;

    environment.systemPackages = with pkgs; [
      flatpak
      gnome-software
    ];

    systemd.services.flatpak-repo = {
      wantedBy = ["multi-user.target"];
      path = [pkgs.flatpak];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };
  };
}
