{
  config,
  lib,
  pkgs,
  hostVariables,
  ...
}: let
  cfg = config.modules.printer.sane;
in {
  options.modules.printer.sane = {
    enable = lib.mkEnableOption "sane";
    description = lib.mkOption {
      type = lib.types.str;
      default = "Sane-Backends";
    };
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
