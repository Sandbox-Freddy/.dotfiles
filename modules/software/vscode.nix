{
  pkgs,
  lib,
  config,
  nix-vscode-extensions,
  ...
}: {
  options.modules.software.vscode = {
    enable = lib.mkEnableOption "vscode";
  };
  config = lib.mkIf config.modules.software.vscode.enable {
    environment.systemPackages = with pkgs; [
      (vscode-with-extensions.override {
        vscodeExtensions = let
          vscode-extensions = nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system};
        in
          with pkgs.lib.foldl' (acc: set: pkgs.lib.recursiveUpdate acc set) {} [
            vscode-extensions.vscode-marketplace
            # vscode-extensions.open-vsx # TODO use after ms-toolsai.jupyter is updated to v2024.8.x
            vscode-extensions.vscode-marketplace-release
            # vscode-extensions.open-vsx-release # TODO use after ms-toolsai.jupyter is updated to v2024.8.x
          ]; [
            # general
            atommaterial.a-file-icon-vscode
            # nix
            bbenoist.nix
            mkhl.direnv
            # javascript/typescript
            esbenp.prettier-vscode
            dbaeumer.vscode-eslint
            #python
            ms-python.python
            ms-python.debugpy
            # ide keybindings
            k--kato.intellij-idea-keybindings

            # Rust
            rust-lang.rust-analyzer
          ];
      })
    ];
  };
}
