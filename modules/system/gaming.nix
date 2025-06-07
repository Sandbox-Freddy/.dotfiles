{
  pkgs,
  config,
  lib,
  ...
}: {
  options.modules.system.gaming = {
  enable =lib.mkEnableOption "gaming";
  };

  config = lib.mkIf config.modules.system.gaming.enable {
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;

    hardware.graphics.extraPackages = with pkgs; [
      nvidia-vaapi-driver
      vulkan-validation-layers
    ];
    programs.gamemode.enable = true;
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
      protonup-qt
      dxvk
      vkd3d-proton
      bottles
      mangohud
    ];

    environment.variables = {
      MANGOHUD = "0";
    };
  };
}
