{
  config,
  lib,
  hostVariables,
  ...
}: {
  options.modules.software.zed.enable = lib.mkEnableOption "zed-editor";

  config = lib.mkIf config.modules.software.zed.enable {
    home-manager.users.${hostVariables.username} = {
      programs.zed-editor = {
        enable = true;
        extensions = [ "nix" "material-icon-theme" ];
        userSettings = {
          load_direnv = "shell_hook";
        };
      };
    };
  };
}
