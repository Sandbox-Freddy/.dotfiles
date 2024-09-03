{hostVariables, ...}: {
  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake /home/${hostVariables.username}/.dotfiles#${hostVariables.host}";
    update = "nix flake update /home/${hostVariables.username}/.dotfiles/flake.nix";
    format = "alejandra";
  };
}
