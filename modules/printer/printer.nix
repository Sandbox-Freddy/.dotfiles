{
  pkgs,
  config,
  lib,
  hostVariables,
  ...
}: {
  options.modules.printer.printer = {
    enable = lib.mkEnableOption "printer";
  };

  config = lib.mkIf config.modules.printer.printer.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.printing = {
      enable = true;
      drivers = with pkgs; [
        epson-escpr
      ];
    };

    hardware.printers = {
      ensureDefaultPrinter = "Epson_XP-3105";
      ensurePrinters = [
        {
          name = "Epson_XP-3105";
          location = "Home";
          description = "Epson XP-3105 (WiFi)";
          deviceUri = "ipp://${hostVariables.printerIp}/ipp/print";
          model = "epson-inkjet-printer-escpr/Epson-XP-3100_Series-epson-escpr-en.ppd";
        }
      ];
    };
  };
}
