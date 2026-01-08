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
          "bruno.desktop"
          "idea.desktop"
          "microsoft-edge.desktop"
          "org.keepassxc.KeePassXC.desktop"
          "com.yubico.yubioath.desktop"
          "org.gnome.Nautilus.desktop"
          "org.gnome.TextEditor.desktop"
          "firefox.desktop"
          "Logseq.desktop"
        ];
        idle-delay = 300;
        left-handed = false;
      };
  }
