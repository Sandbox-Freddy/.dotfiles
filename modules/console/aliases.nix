{hostVariables, ...}: {
  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake /home/${hostVariables.username}/.dotfiles#${hostVariables.host}";
    update = "nix flake update --flake /home/${hostVariables.username}/.dotfiles";
    nixfmt = "alejandra ./";
  };
}
