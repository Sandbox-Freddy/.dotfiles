let
  default = import ./../../variables/defaultVariables.nix;
in
  default
  // {
    host = "work";
    modules =
      default.modules
      // {
        driver =
          default.modules.driver
          // {
            amdgpu = true;
          };
        software =
          default.modules.software
          // {
            display-link = true;
          };
      };
    git =
      default.git
      // {
        includes = [
          {
            path = "~/Dev/.gitconfig";
            condition = "gitdir:~/Dev/";
          }
        ];
      };
    gnome =
      default.gnome
      // {
        fav-icon = [
          "org.gnome.Console.desktop"
          "firefox.desktop"
          "bruno.desktop"
          "idea-ultimate.desktop"
          "org.keepassxc.KeePassXC.desktop"
          "com.yubico.authenticator.desktop"
          "org.gnome.Nautilus.desktop"
          "org.gnome.TextEditor.desktop"
          "chrome-cadlkienfkclaiaibeoongdcgmdikeeg-Default.desktop"
          "chrome-cifhbcnohmdccbgoicgdjpfamggdegmo-Default.desktop"
          "google-chrome.desktop"
          "code.desktop"
          "chrome-faolnafnngnfdaknnbpnkhgohbobgegn-Default.desktop"
        ];
      };
  }
