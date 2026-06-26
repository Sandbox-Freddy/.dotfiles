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
      alsa.support32Bit = false;
      pulse.enable = true;
      jack.enable = true;
    };

    environment.systemPackages = with pkgs; [
      pavucontrol
      crosspipe
      qpwgraph
    ];

    home-manager.users.${hostVariables.username} = {
      services.easyeffects.enable = true;

      home.file.".config/easyeffects/input/jabra-noise-cancellation.json".source =
        ./easyeffects-jabra-noise-cancellation.json;

      home.file.".config/easyeffects/db/easyeffectsrc" = {
        source = ./easyeffects-settings.ini;
        force = true;
      };

      dconf.settings = {
        "com/github/wwmm/easyeffects" = {
          last-used-input-preset = "jabra-noise-cancellation";
        };
      };
    };
  };
}
