let
  inherit (import ./../../variables/defaultVariables.nix) mkHostVariables;
in
  mkHostVariables "work" {
    driver = {
      amdgpu = true;
    };
    software = {
      displaylink = true;
      python = true;
      ssh = true;
      yubikey = true;
      zed = true;
      zeiterfassung = true;
    };
  }
