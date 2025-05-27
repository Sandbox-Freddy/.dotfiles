{
  pkgs,
  lib,
  config,
  ...
}: {
  options.modules.software.noisetorch = {
    enable = lib.mkEnableOption "noisetorch";
  };

  config = lib.mkIf config.modules.software.noisetorch.enable {
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

    systemd.user.services.noisetorch = {
      enable = true;
      description = "Start NoiseTorch at login";
      after = ["pipewire.service" "default.target"];

      serviceConfig = {
        ExecStart = "${pkgs.noisetorch}/bin/noisetorch -i";
        Restart = "always";
        Environment = "DISPLAY=:0";
      };

      wantedBy = ["default.target"];
    };
  };
}
