{
  config,
  pkgs,
  lib,
  hostVariables,
  mkOutOfStorePath,
  ...
}: {
  options.modules.console.fish = {
    enable = lib.mkEnableOption "fish";
  };

  config = lib.mkIf config.modules.console.fish.enable {
    assertions = [
      {
        assertion = builtins.isAttrs (builtins.fromJSON (builtins.readFile ./oh-my-posh/theme/atomic.omp.json));
        message = "oh-my-posh theme atomic.omp.json is not a JSON object";
      }
    ];

    programs.fish.enable = true;
    users.users.${hostVariables.username}.shell = pkgs.fish;

    home-manager.users.${hostVariables.username} = {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          # Disable greeting
          set fish_greeting
          bind shift-right 'ranger-cd; commandline -f repaint'
        '';
        functions.ranger-cd = ''
          set tempfile (mktemp -t ranger-cdXXXXXX)
          ${pkgs.ranger}/bin/ranger --choosedir=$tempfile $argv
          if test -f "$tempfile"
            set rangerdir (cat $tempfile)
            if test -n "$rangerdir" -a "$rangerdir" != (pwd)
              cd -- $rangerdir
            end
            rm -f -- $tempfile
          end
        '';
      };

      programs.ranger = {
        enable = true;
      };
      programs.oh-my-posh = {
        enable = true;
        enableFishIntegration = true;
        configFile = mkOutOfStorePath ./oh-my-posh/theme/atomic.omp.json;
      };
      programs.atuin = {
        enable = true;
        enableFishIntegration = true;
      };
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      home.file.".config/atuin/config.toml".text = ''
        enter_accept = true
        filter_mode = "workspace"
        workspaces = true
      '';
    };
  };
}
