{
  username = "freddy";
  host = "thinclient";
  system = "x86_64-linux";
  stateVersion = "24.11";
  modules = {
    driver = {
      nvidia = false;
      amdgpu = false;
    };
    docker = true;
    display-link = false;
    discord = false;
    git = true;
    flatpak = true;
    idea-ultimate = false;
    webstorm = false;
    lutris = false;
    noisetorch = false;
    steam = true;
    gnome = true;
    kde = false;
    vscode = true;
  };
  systemSettings = {
    bootanimation = false;
    printer = false;
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
      "code.desktop"
      "com.valvesoftware.SteamLink.desktop"
      "vlc.desktop"
      "org.gnome.Nautilus.desktop"
    ];
  };
}
