let
  localPath = /home/freddy/.dotfiles/variables/local.nix;
  local =
    if builtins.pathExists localPath
    then import localPath
    else {};

  # Deep-merge two attribute sets (right side wins, recursing into nested sets).
  deepMerge = lhs: rhs:
    lhs
    // builtins.mapAttrs (
      name: value:
        if builtins.isAttrs value && builtins.isAttrs (lhs.${name} or {})
        then deepMerge lhs.${name} value
        else value
    )
    rhs;

  defaults = {
    username = "freddy";
    description = "Frederik";
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
        python = false;
        easyeffects = true;
        zed = false;
      };
      systemSettings = {
        bootanimation = true;
      };
    };
  };
in {
  # Build per-host variables from a set of module overrides.
  mkHostVariables = host: moduleOverrides:
    deepMerge defaults {
      inherit host;
      modules = moduleOverrides;
    }
    // local;
}
