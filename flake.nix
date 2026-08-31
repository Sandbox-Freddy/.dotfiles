{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    flake-utils,
    home-manager,
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
                  chrome-wayland = pkgs-unstable.google-chrome.override {
                    commandLineArgs = [
                      "--ozone-platform=wayland"
                      "--disable-gtk-ime"
                      "--disable-features=PdfOopif"
                    ];
                  };
                })
              ];
            }
          ];
        specialArgs = {
          inherit hostVariables;
        };
      };
  in
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        packages = {
          inherit (pkgs) alejandra;
        };
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              alejandra
              nixpkgs-fmt
            ];
          };
        };
      }
    )
    // {
      nixosConfigurations = {
        work = mkNixosConfiguration {
          modules = [./hosts/work/configuration.nix];
          hostVariables = import ./hosts/work/variables.nix;
        };
        freddy-laptop = mkNixosConfiguration {
          modules = [./hosts/freddy-laptop/configuration.nix];
          hostVariables = import ./hosts/freddy-laptop/variables.nix;
        };
        thinclient = mkNixosConfiguration {
          modules = [./hosts/thinclient/configuration.nix];
          hostVariables = import ./hosts/thinclient/variables.nix;
        };
      };
    };
}
