let
  default = import ./../../variables/defaultVariables.nix;
in
  default
  // {
    host = "private";
    modules =
      default.modules
      // {
        driver =
          default.modules.driver
          // {
            nvidia = true;
          };
        discord = true;
        webstorm = true;
        lutris = true;
        steam = true;
      };
    gnome =
      default.gnome
      // {
        fav-icon = [
          "org.gnome.Console.desktop"
          "bitwarden.desktop"
          "firefox.desktop"
          "webstorm.desktop"
          "code.desktop"
          "steam.desktop"
          "discord-ptb.desktop"
          "org.gnome.Nautilus.desktop"
        ];
      };
  }
