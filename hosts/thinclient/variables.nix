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
      };
    gnome =
      default.gnome
      // {
        fav-icon = [
          "org.gnome.Console.desktop"
          "firefox.desktop"
          "webstorm.desktop"
          "com.valvesoftware.SteamLink.desktop"
          "vlc.desktop"
          "org.gnome.Nautilus.desktop"
        ];
      };
  }
