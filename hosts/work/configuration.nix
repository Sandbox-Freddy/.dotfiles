{
  hostVariables,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

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

  # AWS tooling. `assume` has to be a fish alias because it sources a .fish
  # file; the rest of the AWS setup is the shellAliases block at the bottom.
  home-manager.users.${hostVariables.username} = {
    programs.fish.shellAliases = {
      assume = "source ${pkgs.granted}/share/assume.fish";
    };
    home.file.".config/fish/completions/aws.fish".text = ''
      complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
    '';

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
