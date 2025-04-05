{hostVariables, ...}: {
  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake /home/${hostVariables.username}/.dotfiles#${hostVariables.host}";
    update = "nix flake update --flake /home/${hostVariables.username}/.dotfiles";
    switch = "nh os switch -H ${hostVariables.host} /home/${hostVariables.username}/.dotfiles";
    securebootsign = "sudo find /boot/EFI/nixos -name '*bzImage.efi' -exec sbctl sign {} \\;";
    nixfmt = "alejandra ./";
  };
}
