{
  config,
  pkgs,
  lib,
  hostVariables,
  ...
}: {
  options.modules.console.fish = {
    enable = lib.mkEnableOption "fish";
  };

  config = lib.mkIf config.modules.console.fish.enable {
    programs.fish.enable = true;
    users.users.${hostVariables.username}.shell = pkgs.fish;

    home-manager.users.${hostVariables.username} = lib.mkMerge [
      {
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
          settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./oh-my-posh/theme/atomic.omp.json));
        };
        programs.atuin = {
          enable = true;
          enableFishIntegration = true;
        };
        home.file.".config/atuin/config.toml".text = ''
          enter_accept = true
          filter_mode = "workspace"
          workspaces = true
        '';
      }
      (lib.mkIf (hostVariables.host == "work") {
        programs.fish.shellAliases = {
          assume = "source ${pkgs.granted}/share/assume.fish";
        };
        home.file.".config/fish/completions/aws.fish".text = ''
          complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
        '';
      })
    ];
  };
}
