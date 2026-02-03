{
  config,
  lib,
  pkgs,
  hostVariables,
  ...
}: {
  options.modules.system.bootanimation = {
    enable = lib.mkEnableOption "bootanimation";
  };

  config = lib.mkIf config.modules.system.bootanimation.enable {
    boot.plymouth.themePackages = let
      pedroRaccoonTheme = pkgs.stdenvNoCC.mkDerivation {
        pname = "pedro-raccoon-plymouth";
        version = "1.0";
        src = pkgs.fetchzip {
          url = "https://github.com/FilaCo/pedro-raccoon-plymouth/releases/download/v1.0/pedro-raccoon.zip";
          hash = lib.fakeSha256; # TODO: replace with the real hash from nix-prefetch
          stripRoot = false;
        };
        installPhase = ''
          runHook preInstall
          mkdir -p $out/share/plymouth/themes
          cp -r ./* $out/share/plymouth/themes/
          runHook postInstall
        '';
      };
    in [pedroRaccoonTheme];

    # Plymouth aktivieren
    boot.plymouth.enable = true;

    # Optional: Theme auswählen
    boot.plymouth.theme = "pedro-raccoon"; # oder "spinner", "fade-in", "text", "tribar" …

    # Initrd muss systemd verwenden – hast du schon ✅
    boot.initrd.systemd.enable = true;
  };
}
