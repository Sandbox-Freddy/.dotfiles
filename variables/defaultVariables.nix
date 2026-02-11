let
  localPath = /home/freddy/.dotfiles/variables/local.nix;
  local =
    if builtins.pathExists localPath
    then import localPath
    else {};
in
{
  username = "freddy";
  description = "Frederik Nies";
  host = "default";
  system = "x86_64-linux";
  location = "de_DE.UTF-8";
  stateVersion = "25.11";
  printerIp = "";
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
    printer = {
      printer = false;
      sane = false;
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
} // local
