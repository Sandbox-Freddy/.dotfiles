{
  hostVariables,
  config,
  ...
}: {
  nix = let
    nixSettings = builtins.fromJSON (builtins.readFile ../../nix-settings.json);
  in {
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };
    settings = rec {
      auto-optimise-store = true;
      experimental-features = nixSettings."experimental-features";
      trusted-users = [hostVariables.username];
      substituters = nixSettings.substituters;
      trusted-public-keys = nixSettings."trusted-public-keys";
      trusted-substituters = substituters;
    };
    extraOptions = ''
      !include ${config.users.users.${hostVariables.username}.home}/.nix.conf
    '';
  };
}
