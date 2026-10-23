{
  config,
  lib,
  pkgs,
  hostVariables,
  ...
}: let
  cfg = config.modules.software.opencode;
in {
  options.modules.software.opencode.enable = lib.mkEnableOption "opencode";

  config = lib.mkIf cfg.enable {
    home-manager.users.${hostVariables.username}.home.packages = [
      pkgs.unstable.opencode
    ];
  };
}
