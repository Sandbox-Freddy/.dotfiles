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
            easyeffects = false;
            zed-editor = true;
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
