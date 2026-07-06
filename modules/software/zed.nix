{
  config,
  pkgs,
  lib,
  ...
}: {
  options.modules.software.zed.enable = lib.mkEnableOption "zed-editor";

  config = lib.mkIf config.modules.software.zed.enable {
    environment.systemPackages = [
      pkgs.zed-editor
    ];

    programs.zed-editor ={
      enable = true;
      extensions = [ "nix" "material-icon-theme" ];
      load_direnv = "shell_hook";
    }
  };
}
