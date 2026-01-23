{
  config,
  pkgs,
  lib,
  hostVariables,
  ...
}: let
  cfg = config.modules.software.git;
in {
  options.modules.software.git = {
    enable = lib.mkEnableOption "git";
    userName = lib.mkOption {
      type = lib.types.str;
      default = "Sandbox-Freddy";
      description = "Git user name";
    };
    userEmail = lib.mkOption {
      type = lib.types.str;
      default = "31123359+Sandbox-Freddy@users.noreply.github.com";
      description = "Git user email";
    };
    lfs = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Git LFS";
    };
    includes = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [];
      description = "Git includes";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.gitFull
    ];

    home-manager.users.${hostVariables.username} = {
      programs.git = {
        enable = true;
        lfs.enable = cfg.lfs;
        settings = {
          user = {
            email = cfg.userEmail;
            name = cfg.userName;
          };
          init.defaultBranch = "main";
          credential.helper = "libsecret";
        };
        includes = cfg.includes;
      };
    };
  };
}
