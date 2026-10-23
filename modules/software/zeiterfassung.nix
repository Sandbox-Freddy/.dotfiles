{
  config,
  lib,
  hostVariables,
  ...
}: let
  cfg = config.modules.software.zeiterfassung;
  flakeRef = "git+ssh://github-work/liko-zeit/zeit-app-electron";
in {
  options.modules.software.zeiterfassung.enable = lib.mkEnableOption "zeiterfassung (SAP-Zeiterfassung Electron app, private repo)";

  config = lib.mkIf cfg.enable {
    home-manager.users.${hostVariables.username} = {
      lib,
      pkgs,
      ...
    }: {
      home.activation.zeiterfassung = lib.hm.dag.entryAfter ["writeBoundary"] ''
        PATH="${pkgs.nix}/bin:$PATH"
        if ! nix profile list | grep -q "zeit-app-electron"; then
          run nix profile install "${flakeRef}"
        fi
      '';
    };
  };
}
