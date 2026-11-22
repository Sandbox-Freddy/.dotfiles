let
  inherit (import ./../../variables/defaultVariables.nix) mkHostVariables;
in
  mkHostVariables "freddy-pc" {
    hardware = {
      yubikey = true;
    };
    software = {
      gaming = true;
      lmstudio = true;
      opencode = true;
    };
  }
