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

            function __atuin_install --on-event fish_prompt
              functions -e __atuin_install
              bind -M insert -k up _atuin_bind_up
              bind -M default -k up _atuin_bind_up
              bind up _atuin_bind_up
            end
          '';
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
        home.file.".config/fish/completions/aws.fish".text = ''
          complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
        '';
      })
    ];
  };
}
