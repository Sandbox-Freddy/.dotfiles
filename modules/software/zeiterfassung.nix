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

  # Installed imperatively via `nix profile` instead of as a flake input/overlay,
  # since the repo is private: a flake input would force CI (which has no SSH
  # access to it) to fetch it on every build, even for hosts that don't need it.
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
