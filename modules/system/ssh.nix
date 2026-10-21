{
  config,
  lib,
  hostVariables,
  ...
}: let
  cfg = config.modules.system.ssh;
in {
  options.modules.system.ssh = {
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
