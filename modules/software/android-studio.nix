{
  pkgs,
  lib,
  config,
  hostVariables,
  ...
}: {
  options.modules.software.android-studio = {
    enable = lib.mkEnableOption "android-studio";
  };
  config = lib.mkIf config.modules.software.android-studio.enable {
    environment.systemPackages = with pkgs; [
      android-studio
    ];
  };
}
