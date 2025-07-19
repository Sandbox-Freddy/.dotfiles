{
  config,
  lib,
  hostVariables,
  ...
}: {
  options.modules.system.printer = {
    enable = lib.mkEnableOption "printer";
  };

  config = lib.mkIf config.modules.system.printer.enable {
    services.printing.enable = true;
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
