let
  inherit (import ./../../variables/defaultVariables.nix) mkHostVariables;
in
  mkHostVariables "thinclient" {
    hardware = {
      scanbutton = true;
      scanner = true;
    };
    software = {
      zed = true;
    };
  }
