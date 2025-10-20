let
  default = import ./../../variables/defaultVariables.nix;
in
  default
  // {
    host = "thinclient";
    modules =
      default.modules
      // {
        software =
          default.modules.software
          // {
            flatpak = true;
            noisetorch = false;
          };
        systemSettings =
          default.modules.systemSettings
          // {
            scanner = true;
          };
      };
    gnome =
      default.gnome
      // {
        fav-icon = [
          "org.gnome.Console.desktop"
          "bitwarden.desktop"
          "firefox.desktop"
          "webstorm.desktop"
          "com.valvesoftware.SteamLink.desktop"
          "vlc.desktop"
          "org.gnome.Nautilus.desktop"
        ];
      };
  }
