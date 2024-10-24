{hostVariables, ...}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${hostVariables.username} = {
    # basic home-manager config
    home.username = "${hostVariables.username}";
    home.homeDirectory = "/home/${hostVariables.username}";
    home.stateVersion = "24.05";
    programs.home-manager.enable = true;
  };
}
