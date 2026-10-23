let
  inherit (import ./../../variables/defaultVariables.nix) mkHostVariables;
in
  mkHostVariables "freddy-laptop" {
    hardware = {
      nvidia = true;
      printing = true;
      yubikey = true;
    };
    software = {
      gaming = true;
      opencode = true;
    };
  }
