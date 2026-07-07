{hostVariables, ...}: {
  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake /home/${hostVariables.username}/.dotfiles#${hostVariables.host} --impure";
    update = "nix flake update --flake /home/${hostVariables.username}/.dotfiles";
    switchnix = "nh os switch -H ${hostVariables.host} /home/${hostVariables.username}/.dotfiles --impure";
    cleanup = "sudo nix-collect-garbage --delete-older-than 3d";
    nixfmt = "alejandra ./";
  };
}
