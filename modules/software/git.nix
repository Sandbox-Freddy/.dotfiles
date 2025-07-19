{
  config,
  pkgs,
  lib,
  hostVariables,
  ...
}: {
  options.modules.software.git = {
    enable = lib.mkEnableOption "git";
  };

  config = lib.mkIf config.modules.software.git.enable {
    environment.systemPackages = [
      pkgs.gitFull
    ];

    home-manager.users.${hostVariables.username} = {
      programs.git = {
        enable = true;
        lfs.enable = hostVariables.git.lfs;
        extraConfig = {
          init.defaultBranch = hostVariables.git.extraConfig.defaultBranch;
          credential.helper = hostVariables.git.extraConfig.credential-helper;
        };
        userEmail = hostVariables.git.credentials.email;
        userName = hostVariables.git.credentials.name;
        includes = hostVariables.git.includes;
      };
    };
  };
}
