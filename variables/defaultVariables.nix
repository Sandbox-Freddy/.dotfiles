{
  username = "freddy";
  host = "default";
  system = "x86_64-linux";
  stateVersion = "25.05";
  modules = {
    android-studio = false;
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
    noisetorch = true;
    gnome = true;
    kde = false;
    vscode = true;
    hyperland = false;
  };
  systemSettings = {
    bootanimation = true;
    gaming = false;
    printer = true;
    virtualization = false;
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
