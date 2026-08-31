let
  inherit (import ./../../variables/defaultVariables.nix) mkHostVariables;
in
  mkHostVariables "thinclient" {
    software = {
      flatpak = true;
      easyeffects = false;
      zed = true;
    };
    printer = {
      sane = true;
      scanbutton = true;
      scanbuttonOutDir = "/mnt/paperless";
      scanbuttonBlankPageThreshold = 0.985;
      scanbuttonBlackBorderTrimFuzz = "32%";
    };
  }
