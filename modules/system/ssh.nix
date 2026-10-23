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
        # home-manager is removing these defaults; carrying them explicitly
        # keeps the generated config identical once they are gone.
        enableDefaultConfig = false;
        settings =
          lib.recursiveUpdate {
            "*" = {
              AddKeysToAgent = "no";
              Compression = false;
              ControlMaster = "no";
              ControlPath = "~/.ssh/master-%r@%n:%p";
              ControlPersist = "no";
              ForwardAgent = false;
              HashKnownHosts = false;
              ServerAliveCountMax = 3;
              ServerAliveInterval = 0;
              UserKnownHostsFile = "~/.ssh/known_hosts";
            };
          }
          cfg.settings;
      };
    };
  };
}
