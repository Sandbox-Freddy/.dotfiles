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
      description = "CUPS device URI for the Epson XP-3105.";
    };
    description = lib.mkOption {
      type = lib.types.str;
      default = "Epson XP-3105";
      description = "Human-readable printer description.";
    };
    location = lib.mkOption {
      type = lib.types.str;
      default = "Home";
      description = "Printer location label.";
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