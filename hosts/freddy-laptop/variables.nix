let
  default = import ./../../variables/defaultVariables.nix;
in
  default
  // {
    host = "freddy-laptop";
    modules =
      default.modules
      // {
        driver =
          default.modules.driver
          // {
            nvidia = true;
          };
        printer =
          default.modules.printer
          // {
            printer = true;
            sane = true;
            scanbutton = true;
          };
        software =
          default.modules.software
          // {
            wine = true;
          };
        systemSettings =
          default.modules.systemSettings
          // {
            gaming = true;
          };
      };
  }
