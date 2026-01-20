{
  username = "freddy";
  description = "Frederik Nies";
  host = "default";
  system = "x86_64-linux";
  location = "de_DE.UTF-8";
  stateVersion = "25.11";
  modules = {
    console = {
      fish = true;
    };
    driver = {
      nvidia = false;
      amdgpu = false;
    };
    gui = {
      gnome = true;
    };
    software = {
      display-link = false;
      docker = true;
      flatpak = false;
      git = true;
      noisetorch = true;
      wine = false;
      ollama = false;
    };
    systemSettings = {
      bootanimation = true;
      gaming = false;
    };
  };
  git = {
    lfs = true;
    extraConfig = {
      defaultBranch = "main";
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
    idle-delay = 0;
    left-handed = true;
  };
}
