{hostVariables, ...}: {
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [hostVariables.username];
    };
    extraOptions = ''
      !include /home/${hostVariables.username}/.nix.conf
    '';
  };
}
