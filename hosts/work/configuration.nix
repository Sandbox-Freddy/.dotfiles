{
  hostVariables,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Modules
  modules.gui.gnome = {
    favoriteApps = [
      "org.gnome.Console.desktop"
      "bruno.desktop"
      "obsidian.desktop"
      "dev.zed.Zed.desktop"
      "SourceGit.desktop"
      "chrome-cifhbcnohmdccbgoicgdjpfamggdegmo-Default.desktop"
      "chrome-faolnafnngnfdaknnbpnkhgohbobgegn-Default.desktop"
      "google-chrome.desktop"
      "org.keepassxc.KeePassXC.desktop"
      "com.yubico.yubioath.desktop"
      "org.gnome.Nautilus.desktop"
      "org.gnome.TextEditor.desktop"
      "firefox.desktop"
    ];
    idleDelay = 300;
    leftHanded = false;
  };

  modules.software.git = {
    includes = [
      {
        path = "~/Dev/.gitconfig";
        condition = "gitdir:~/Dev/";
      }
    ];
  };

  modules.system.ssh = {
    settings = {
      "github-personal" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
      };
      "github-work" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/work_github";
      };
    };
  };

  home-manager.users.${hostVariables.username} = {
    home.packages = with pkgs; [
      aisleriot
      awscli2
      chrome-wayland
      claude-code
      drawio
      granted
      jq
      keepassxc
      nodejs_24
      obsidian
      pinta
      unstable.bruno
      unstable.dbeaver-bin
      xournalpp
    ];
  };

  environment.shellAliases = {
    awsssologin = "aws sso login --no-browser --sso-session";
  };
}
