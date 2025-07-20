{
  pkgs,
  lib,
  config,
  hostVariables,
  ...
}: {
  options.modules.system.scanner = {
    enable = lib.mkEnableOption "scanner";
  };
  config = lib.mkIf config.modules.system.scanner.enable {
    hardware.sane = {
      enable = true;
      extraBackends = [pkgs.sane-airscan];
      disabledDefaultBackends = ["escl"]; # optional
    };
    services.udev.packages = [pkgs.sane-airscan];

    services.avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
      };
    };

    users.users.${hostVariables.username} = {
      extraGroups = ["scanner" "lp"];
    };
  };
}
