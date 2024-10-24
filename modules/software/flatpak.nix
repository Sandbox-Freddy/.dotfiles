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

        environment.systemPackages = with pkgs;[
            flatpak
        ];
    };
}
