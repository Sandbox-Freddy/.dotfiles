{hostVariables, ...}: let
  inherit (hostVariables) dotfilesDir host;
in {
  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ${dotfilesDir}#${host} --impure";
    update = "nix flake update --flake ${dotfilesDir}";
    switchnix = "nh os switch -H ${host} ${dotfilesDir} --impure";
    cleanup = "sudo nix-collect-garbage --delete-older-than 3d";
    nixfmt = "alejandra ./";
  };
}
