{
  username = "freddy";
  host = "private";
  system = "x86_64-linux";
  stateVersion = "24.11";
  printer = true;
  modules = {
    driver = {
      nvidia = true;
      amdgpu = false;
    };
    docker = true;
    display-link = false;
    discord = true;
    git = true;
    flatpak = false;
    idea-ultimate = false;
    webstorm = true;
    lutris = true;
    noisetorch = true;
    steam = true;
    gnome = true;
    kde = false;
    vscode = true;
  };
  git = {
    lfs = true;
    extraConfig = {
      defaultBranch = "main";
      credential-helper = "store";
    };
    credentials = {
      email = "31123359+Sandbox-Freddy@users.noreply.github.com";
      name = "Sandbox-Freddy";
    };
    includes = [];
  };
  gnome = {
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
