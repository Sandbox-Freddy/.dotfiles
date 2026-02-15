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
        printer =
          default.modules.printer
          // {
            sane = true;
            scanbutton = true;
            scanbuttonOutDir = "/mnt/paperless";
            scanbuttonBlankPageThreshold = 0.985;
            scanbuttonBlackBorderTrimFuzz = "32%";
          };
      };
  }
