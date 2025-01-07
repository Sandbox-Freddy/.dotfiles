# Nixos Multi-Client Configuration
## Useage
Create a `.dotfiles` folder in the home directory. Check out the project in .dotfiles folder. To use one of the existing hosts, adjust the variables.nix in `./hosts/{private or work}/variables.nix`.
When building for the first time, you must execute the command. 
`sudo nixos-rebuild switch --flake /home/USERNAME/.dotfiles#private_OR_work`.
The system can then be rebuilt using the `rebuild` command.

If you want to create a new host, a new folder must be created in the `./hosts` directory.  In the new folder, `default.nix`, `configration.nix`, `hardware-configuration.nix`, `home.nix` and `variables.nix` must be created.
The variables.nix must contain the following variables
```
{
  username = "";
  host = "";
  system = "";
  stateVersion = "";
  printer = true;
  modules = {
    driver = {
      nvidia = false;
      amdgpu = true;
    };
    docker = true;
    discord = true;
    display-link = true;
    git = true;
    flatpak = false;
    jetbrains = true;
    lutris = true;
    steam = true;
    gnome = true;
    vscode = true;
  };
  git = {
    lfs = true;
    extraConfig = {
      defaultBranch = "main";
      credential-helper = "store";
    };
    credentials = {
      email = "";
      name = "";
    };
    includes = [];
  };
  gnome = {
    fav-icon = [];
  };
}
```
Adapt the variables to your system.The new host must then be added to flake.nix in the root directory.
```
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };
  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nix-vscode-extensions,
    ...
  }: let
    mkNixosConfiguration = {
      modules ? [],
      hostVariables,
    }: let
      system = hostVariables.system;
      pkgs-config = {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import inputs.nixpkgs-unstable pkgs-config;
    in
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
          modules
          ++ [
            ./configuration.nix
            ./modules
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = [
                (final: prev: {
                  unstable = pkgs-unstable;
                })
              ];
            }
          ];
        specialArgs = {
          inherit hostVariables;
          inherit nix-vscode-extensions;
        };
      };
  in {
    nixosConfigurations = {
      work = mkNixosConfiguration {
        modules = [./hosts/work];
        hostVariables = import ./hosts/work/variables.nix;
      };
      private = mkNixosConfiguration {
        modules = [./hosts/private];
        hostVariables = import ./hosts/private/variables.nix;
      };
      NEW-HOST-NAME-LIKE-THE-FOLDER = mkNixosConfiguration {
        modules = [./hosts/HOST-FOLDER];
        hostVariables = import ./hosts/HOST-FOLDER/variables.nix;
      };
    };
    overlays = import ./overlays.nix inputs;
  };
}
```
Important: If you have added a new client, please remember to include ./home.nix in the imports section of configuration.nix for that client.”
The new host can then be built with this `sudo nixos-rebuild switch --flake /home/USERNAME/.dotfiles#NAME_OF_NEW_HOST`