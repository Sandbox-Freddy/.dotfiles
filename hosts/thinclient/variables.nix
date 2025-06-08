let
  default = import ./../../variables/defaultVariables.nix;
in
  default
  // {
    host = "thinclient";
    modules =
      default.modules
      // {
        flatpak = true;
        noisetorch = false;
      };
    gnome =
      default.gnome
      // {
        fav-icon = [
          "org.gnome.Console.desktop"
          "bitwarden.desktop"
          "firefox.desktop"
          "code.desktop"
          "com.valvesoftware.SteamLink.desktop"
          "vlc.desktop"
          "org.gnome.Nautilus.desktop"
        ];
      };
  }
