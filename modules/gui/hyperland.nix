{
  pkgs,
  lib,
  config,
  hostVariables,
  ...
}: {
  options.modules.gui.hyperland = {
    enable = lib.mkEnableOption "hyperland";
  };
  config = lib.mkIf config.modules.gui.hyperland.enable {
    programs.hyprland.enable = true;

    environment.systemPackages = [
      pkgs.kitty
    ];
  };
}
