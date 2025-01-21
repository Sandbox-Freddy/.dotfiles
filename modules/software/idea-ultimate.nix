{
  pkgs,
  lib,
  config,
  hostVariables,
  ...
}: {
  options.modules.software.idea-ultimate = {
    enable = lib.mkEnableOption "idea-ultimate";
  };
  config = lib.mkIf config.modules.software.idea-ultimate.enable {
    environment.systemPackages = with pkgs; [
      jetbrains.idea-ultimate
    ];
  };
}
