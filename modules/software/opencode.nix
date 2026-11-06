{
  config,
  lib,
  pkgs,
  hostVariables,
  ...
}: let
  cfg = config.modules.software.opencode;
  opencode = pkgs.unstable.opencode.overrideAttrs (oldAttrs:
    lib.optionalAttrs (
      oldAttrs.version
      == "2.2.5"
      && oldAttrs.node_modules.outputHash == "sha256-xfOVcw1+waLVNhFDwzOtzxrUSQEogvn88YomydOlhwc="
    ) {
      # Work around the dependency hash mismatch in the pinned nixpkgs package.
      node_modules = oldAttrs.node_modules.overrideAttrs {
        outputHash = "sha256-prx9dX7kUvs/E3zopkaPk5LXh3xJAy5sZeum/W8L7cA=";
      };
    });
in {
  options.modules.software.opencode.enable = lib.mkEnableOption "opencode";

  config = lib.mkIf cfg.enable {
    home-manager.users.${hostVariables.username}.home.packages = [
      opencode
    ];
  };
}
