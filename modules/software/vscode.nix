{
  config,
  lib,
  hostVariables,
  pkgs,
  ...
}: {
  options.modules.software.vscode.enable = lib.mkEnableOption "vscode";

  config = lib.mkIf config.modules.software.vscode.enable {
    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
      alejandra
      nil
      nixd
    ];

    home-manager.users.${hostVariables.username} = {
      programs.vscode = {
        enable = true;
        profiles.default = {
          extensions = with pkgs.vscode-extensions; [
            jnoortheen.nix-ide
            mkhl.direnv
            eamodio.gitlens
            dbaeumer.vscode-eslint
            esbenp.prettier-vscode
            ms-azuretools.vscode-docker
            hashicorp.terraform
            vue.volar
            redhat.vscode-xml
            k--kato.intellij-idea-keybindings
            pkief.material-icon-theme
            teabyii.ayu
          ];
          userSettings = {
            "files.autoSave" = "afterDelay";
            "files.autoSaveDelay" = 1000;
            "workbench.colorTheme" = "Ayu Dark";
            "workbench.iconTheme" = "material-icon-theme";
            "editor.fontSize" = 17;
            "editor.fontFamily" = "'JetBrainsMono Nerd Font', monospace";
            "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font', monospace";
            "window.zoomLevel" = 0;
            "editor.formatOnSave" = true;
            "git.autofetch" = true;
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "nixd";
            "nix.formatterPath" = "alejandra";
            "[nix]" = {
              "editor.defaultFormatter" = "jnoortheen.nix-ide";
            };
            "[javascript]" = {
              "editor.defaultFormatter" = "esbenp.prettier-vscode";
            };
            "[typescript]" = {
              "editor.defaultFormatter" = "esbenp.prettier-vscode";
            };
            "[typescriptreact]" = {
              "editor.defaultFormatter" = "esbenp.prettier-vscode";
            };
            "editor.codeActionsOnSave" = {
              "source.fixAll.eslint" = "explicit";
            };
          };
        };
      };
    };
  };
}
