{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.printer.epson-xp-3105;
in {
  options.modules.printer.epson-xp-3105 = {
    enable = lib.mkEnableOption "Epson XP-3105 printer support";
    deviceUri = lib.mkOption {
      type = lib.types.str;
      default = "usb://EPSON/XP-3105%20Series";
    };
    description = lib.mkOption {
      type = lib.types.str;
      default = "Epson XP-3105";
    };
    location = lib.mkOption {
      type = lib.types.str;
      default = "Home";
    };
  };

  config = lib.mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = [
        pkgs.epson-escpr2
      ];
    };

    hardware.printers.ensurePrinters = [
      {
        name = "epson-xp-3105";
        inherit (cfg) deviceUri description location;
        model = "drv:///epson-escpr2/epson-escpr2.ppd";
      }
    ];
  };
}
