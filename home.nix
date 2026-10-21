{
  pkgs,
  hostVariables,
  ...
}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${hostVariables.username} = {
    home.username = hostVariables.username;
    home.homeDirectory = "/home/${hostVariables.username}";
    home.stateVersion = hostVariables.stateVersion;
    programs.home-manager.enable = true;

    # Apps every host gets; host-specific ones live in hosts/<host>/configuration.nix
    home.packages = with pkgs; [
      sourcegit
    ];
  };
}
