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
            epson-xp-3105 = false;
            sane = true;
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
