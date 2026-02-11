{hostVariables, ...}: {
  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake /home/${hostVariables.username}/.dotfiles#${hostVariables.host} --impure";
    update = "nix flake update --flake /home/${hostVariables.username}/.dotfiles";
    switchnix = "nh os switch -H ${hostVariables.host} /home/${hostVariables.username}/.dotfiles --impure";
    securebootsign = "sudo sbctl sign /boot/EFI/systemd/systemd-bootx64.efi
                      sudo sbctl sign /boot/EFI/BOOT/BOOTX64.EFI
                      sudo find /boot/EFI/nixos -name '*bzImage.efi' -exec sbctl sign {} \\;";
    nixfmt = "alejandra ./";
  };
}
