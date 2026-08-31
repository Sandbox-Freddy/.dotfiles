let
  inherit (import ./../../variables/defaultVariables.nix) mkHostVariables;
in
  mkHostVariables "work" {
    driver = {
      amdgpu = true;
    };
    software = {
      display-link = true;
      python = true;
      zed = true;
    };
  }
