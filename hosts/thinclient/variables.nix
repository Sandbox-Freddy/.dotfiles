let
  inherit (import ./../../variables/defaultVariables.nix) mkHostVariables;
in
  mkHostVariables "thinclient" {
    printer = {
      sane = true;
      scanbutton = true;
    };
    software = {
      easyeffects = false;
      flatpak = true;
      zed = true;
    };
  }
