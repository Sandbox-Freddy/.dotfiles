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
        # TODO remove after unstable updated to 1.93.0
        vscode = pkgs.vscode.overrideAttrs (old: rec {
          version = "1.93.0";
          plat = "linux-x64";
          src = fetchurl {
            name = "VSCode_${version}_${plat}.tar.gz";
            url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
            sha256 = "24BEzLDg5QLuB4G1OGB+lqEaH+Xy+WULbqaePJHElj4=";
          };
        });

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
          ];
      })
    ];
  };
}
