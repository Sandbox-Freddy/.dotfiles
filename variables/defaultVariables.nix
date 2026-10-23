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

  username = "freddy";

  defaults = {
    inherit username;
    description = "Frederik";
    system = "x86_64-linux";
    location = "de_DE.UTF-8";
    stateVersion = "26.05";
    dotfilesDir = "/home/${username}/.dotfiles";
    printerIp = "";
    # Every entry maps 1:1 onto `modules.<category>.<name>.enable`
    # (see the generated mapping in configuration.nix), so names must match
    # the module paths and values must stay booleans.
    modules = {
      console = {
        fish = true;
      };
      gui = {
        gnome = true;
      };
      hardware = {
        amdgpu = false;
        displaylink = false;
        nvidia = false;
        printing = false;
        scanbutton = false;
        scanner = false;
        yubikey = false;
      };
      software = {
        docker = true;
        gaming = false;
        git = true;
        opencode = false;
        python = false;
        zed = true;
        zeiterfassung = false;
      };
      system = {
        bootanimation = true;
        ssh = false;
      };
    };
  };
in {
  # Build per-host variables from a set of module overrides.
  mkHostVariables = host: moduleOverrides:
    deepMerge (deepMerge defaults {
      inherit host;
      modules = moduleOverrides;
    })
    local;
}
