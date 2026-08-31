let
  inherit (import ./../../variables/defaultVariables.nix) mkHostVariables;
in
  mkHostVariables "freddy-laptop" {
    driver = {
      nvidia = true;
    };
    printer = {
      printer = true;
    };
    software = {
      gaming = true;
      zed = true;
    };
  }
