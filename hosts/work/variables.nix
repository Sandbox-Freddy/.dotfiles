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
        android-studio = true;
        display-link = true;
        idea-ultimate = true;
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
          "google-chrome.desktop"
          "firefox.desktop"
          "chrome-hcmbhdgajegmbifcliiifdgabfomdoeo-Default.desktop"
          "chrome-gpilnghdnjmkagonnhmhajmadneiolhf-Default.desktop"
          "idea-ultimate.desktop"
          "code.desktop"
          "chrome-cadlkienfkclaiaibeoongdcgmdikeeg-Default.desktop"
          "chrome-faolnafnngnfdaknnbpnkhgohbobgegn-Default.desktop"
          "chrome-cifhbcnohmdccbgoicgdjpfamggdegmo-Default.desktop"
          "com.yubico.authenticator.desktop"
          "org.keepassxc.KeePassXC.desktop"
          "org.gnome.Nautilus.desktop"
          "org.gnome.TextEditor.desktop"
        ];
      };
  }
