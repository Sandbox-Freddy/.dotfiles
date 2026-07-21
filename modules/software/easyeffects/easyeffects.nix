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
    # PipeWire base (enable/alsa/pulse) + rtkit live in configuration.nix;
    # easyeffects only needs the JACK layer on top.
    services.pipewire.jack.enable = true;

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
