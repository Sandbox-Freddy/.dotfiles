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
    stateVersion = "26.05";
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
        scanbutton = false;
        scanbuttonOutDir = null;
        scanbuttonBlankPageThreshold = null;
        scanbuttonBlackBorderTrimFuzz = null;
      };
      software = {
        display-link = false;
        docker = true;
        gaming = false;
        flatpak = false;
        git = true;
        easyeffects = false;
      };
      systemSettings = {
        bootanimation = true;
      };
    };
  }
  // local
