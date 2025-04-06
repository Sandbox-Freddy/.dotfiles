{
  username = "freddy";
  host = "default";
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
    flatpak = false;
    idea-ultimate = false;
    webstorm = false;
    lutris = false;
    noisetorch = true;
    steam = false;
    gnome = true;
    kde = false;
    vscode = true;
  };
  systemSettings = {
    bootanimation = true;
    printer = true;
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
    ];
  };
}
