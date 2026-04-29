{
  pkgs,
  lib,
  config,
  hostVariables,
  ...
}: {
  options.modules.software.easyeffects = {
    enable = lib.mkEnableOption "easyeffects";
  };

  config = lib.mkIf config.modules.software.easyeffects.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    environment.systemPackages = with pkgs; [
      pavucontrol
      helvum
      qpwgraph
    ];

    home-manager.users.${hostVariables.username} = {
      services.easyeffects.enable = true;
    };
  };
}