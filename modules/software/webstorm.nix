{
  pkgs,
  lib,
  config,
  hostVariables,
  ...
}: {
  options.modules.software.webstorm = {
    enable = lib.mkEnableOption "webstorm";
  };
  config = lib.mkIf config.modules.software.webstorm.enable {
    environment.systemPackages = with pkgs; [
      jetbrains.webstorm
    ];
  };
}
