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
    matchBlocks = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "SSH config match blocks (programs.ssh.matchBlocks)";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${hostVariables.username} = {
      programs.ssh = {
        enable = true;
        matchBlocks = cfg.matchBlocks;
      };
    };
  };
}
