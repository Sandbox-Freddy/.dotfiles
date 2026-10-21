let
  inherit (import ./../../variables/defaultVariables.nix) mkHostVariables;
in
  mkHostVariables "thinclient" {
    printer = {
      sane = true;
      scanbutton = true;
    };
    software = {
      flatpak = true;
      zed = true;
    };
  }
