{
  config,
  lib,
  pkgs,
  hostVariables,
  ...
}: let
  cfg = config.modules.hardware.scanner;
in {
  options.modules.hardware.scanner = {
    enable = lib.mkEnableOption "scanner (SANE)";
  };

  config = lib.mkIf cfg.enable {
    hardware.sane = {
      enable = true;
      extraBackends = [
        pkgs.sane-backends
      ];
    };

    users.users.${hostVariables.username} = {
      extraGroups = ["scanner" "lp"];
    };

    environment.systemPackages = with pkgs; [
      simple-scan
      gscan2pdf
      xsane
    ];
  };
}
