{
  config,
  lib,
  hostVariables,
  pkgs,
  ...
}: {
  options.modules.software.zed.enable = lib.mkEnableOption "zed-editor";

  config = lib.mkIf config.modules.software.zed.enable {
    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
      nil
      nixd
    ];

    home-manager.users.${hostVariables.username} = {
      programs.zed-editor = {
        enable = true;
        extensions = [
          "nix"
          "material-icon-theme"
          "git-firefly"
          "dockerfile"
          "xml"
          "sql"
          "terraform"
          "vue"
          "fish"
        ];
        userSettings = {
          language_models = {};
          edit_predictions = {
            provider = "zed";
          };
          disable_ai = false;
          proxy = "";
          autosave = {
            after_delay = {
              milliseconds = 1000;
            };
          };
          cli_default_open_behavior = "existing_window";
          buffer_font_weight = 400.0;
          project_panel = {
            dock = "left";
          };
          outline_panel = {
            dock = "left";
          };
          collaboration_panel = {
            dock = "left";
          };
          agent = {
          };
          git_panel = {
            tree_view = true;
            dock = "left";
          };
          diff_view_style = "split";
          base_keymap = "JetBrains";
          icon_theme = {
            mode = "dark";
            light = "Zed (Default)";
            dark = "Material Icon Theme";
          };
          ui_font_size = 18.0;
          buffer_font_size = 17.0;
          theme = {
            mode = "dark";
            light = "One Light";
            dark = "Ayu Dark";
          };
          load_direnv = "shell_hook";
          languages = {
            TypeScript = {
              code_actions_on_format = {
                "source.fixAll.eslint" = true;
              };
              format_on_save = "on";
              formatter = [];
            };
            JavaScript = {
              code_actions_on_format = {
                "source.fixAll.eslint" = true;
              };
              format_on_save = "on";
              formatter = [];
            };
            TSX = {
              code_actions_on_format = {
                "source.fixAll.eslint" = true;
              };
              format_on_save = "on";
              formatter = [];
            };
          };
        };
      };
    };
  };
}
