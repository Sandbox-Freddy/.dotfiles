{
  config,
  lib,
  hostVariables,
  ...
}: let
  cfg = config.modules.software.ssh;
in {
  options.modules.software.ssh = {
    enable = lib.mkEnableOption "ssh";
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "SSH client config blocks (programs.ssh.settings), keyed by host pattern";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${hostVariables.username} = {
      programs.ssh = {
        enable = true;
        settings = cfg.settings;
      };
    };
  };
}
