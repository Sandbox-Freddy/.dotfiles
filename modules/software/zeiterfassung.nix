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
    # The flakeRef resolves through the `github-work` ssh alias, which the host
    # defines on top of this module -- without it the install can only fail.
    assertions = [
      {
        assertion = config.modules.system.ssh.enable;
        message = "modules.software.zeiterfassung needs modules.system.ssh for the github-work alias";
      }
    ];

    home-manager.users.${hostVariables.username} = {
      lib,
      pkgs,
      ...
    }: {
      home.activation.zeiterfassung = lib.hm.dag.entryAfter ["writeBoundary"] ''
        PATH="${pkgs.nix}/bin:$PATH"
        if ! nix profile list | grep -q "zeit-app-electron"; then
          run nix profile install "${flakeRef}" || \
            echo "zeiterfassung: install failed, needs the github-work key in the agent" >&2
        fi
      '';
    };
  };
}
