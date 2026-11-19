let
  inherit (import ./../../variables/defaultVariables.nix) mkHostVariables;
in
  mkHostVariables "work" {
    hardware = {
      amdgpu = true;
      displaylink = true;
      yubikey = true;
    };
    software = {
      python = true;
      vscode = true;
      zeiterfassung = true;
    };
    system = {
      ssh = true;
    };
  }
