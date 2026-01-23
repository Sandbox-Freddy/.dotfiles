let
  default = import ./../../variables/defaultVariables.nix;
in
  default
  // {
    host = "thinclient";
    modules =
      default.modules
      // {
        software =
          default.modules.software
          // {
            flatpak = true;
            noisetorch = false;
          };
      };
  }
