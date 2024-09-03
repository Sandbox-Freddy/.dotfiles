{
  pkgs,
  lib,
  config,
  hostVariables,
  ...
}: {
  options.modules.software.jetbrains = {
    enable = lib.mkEnableOption "jetbrains";
  };
  config = lib.mkIf config.modules.software.jetbrains.enable {
    environment.systemPackages = with pkgs; [
      jetbrains.idea-ultimate
    ];
  };
}
