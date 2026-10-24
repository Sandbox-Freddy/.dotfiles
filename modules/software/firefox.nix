{
  config,
  lib,
  ...
}: let
  cfg = config.modules.software.firefox;
in {
  options.modules.software.firefox.enable = lib.mkEnableOption "firefox";

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      policies.ExtensionSettings = {
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        };
        "adguardadblocker@adguard.com" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/adguard-adblocker/latest.xpi";
        };
        "nordvpnproxy@nordvpn.com" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/nordvpn-proxy-extension/latest.xpi";
        };
        # AdGuard replaces uBlock Origin; blocking the ID also removes an
        # already installed uBlock from existing profiles.
        "uBlock0@raymondhill.net".installation_mode = "blocked";
      };
    };
  };
}
