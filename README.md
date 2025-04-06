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
  username = "freddy";
  host = "work";
  system = "x86_64-linux";
  stateVersion = "24.11";
  modules = {
    driver = {
      nvidia = false;
      amdgpu = true;
    };
    docker = true;
    display-link = true;
    discord = false;
    git = true;
    flatpak = false;
    idea-ultimate = true;
    webstorm = false;
    lutris = false;
    noisetorch = true;
    steam = false;
    gnome = true;
    kde = false;
    vscode = true;
  };
  systemSettings = {
    bootanimation = false;
    printer = false;
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
    includes = [
      {
        path = "";
        condition = "";
      }
    ];
  };
  gnome = {
    fav-icon = [
    ];
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

## Flake example for Dev Environment

```
{
  description = "Development Environment Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [

        ];
      };
    });
}
```
# ⚙️ NixOS Multi-Host Configuration

This repository contains my modular NixOS system configuration, powered by [Nix Flakes](https://nixos.wiki/wiki/Flakes) and [Home Manager](https://nix-community.github.io/home-manager/).

## ✅ Features

- 🔁 Flake-based for reproducibility
- 🧩 Modular configuration per host
- 💻 Includes Home Manager for user-level setup
- 📁 Centralized `variables.nix` for system flags and module toggles

---

## 🏗️ Getting Started

### 1. Clone into `.dotfiles`

```bash
git clone https://github.com/Sandbox-Freddy/.dotfiles ~/.dotfiles
cd ~/.dotfiles
```

### 2. Use an existing host

Edit:

```nix
./hosts/{work,private}/variables.nix
```

Then run:

```bash
sudo nixos-rebuild switch --flake ~/.dotfiles#work
```

For later rebuilds:

```bash
rebuild
```

or 
```bash
switch
```

> `rebuild` and `switch` is an alias for `nixos-rebuild` with predefined arguments.

---

## ➕ Adding a New Host

1. Create a new folder in `./hosts/`, e.g. `my-laptop`
2. Add these files:
    - `configuration.nix`
    - `default.nix`
    - `hardware-configuration.nix`
    - `home.nix`
    - `variables.nix`

3. Your `variables.nix` should follow this structure:

```nix
{
  username = "freddy";
  host = "work";
  system = "x86_64-linux";
  stateVersion = "24.11";

  modules = {
    driver = {
      nvidia = false;
      amdgpu = true;
    };
    docker = true;
    git = true;
    steam = false;
    vscode = true;
    gnome = true;
    kde = false;
    # ...
  };

  systemSettings = {
    bootanimation = false;
    printer = false;
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
    includes = [
      {
        path = "";
        condition = "";
      }
    ];
  };

  gnome = {
    fav-icon = [];
  };
}
```

4. Finally, register the host in your `flake.nix`:

```nix
nixosConfigurations = {
  my-laptop = mkNixosConfiguration {
    modules = [ ./hosts/my-laptop ];
    hostVariables = import ./hosts/my-laptop/variables.nix;
  };
};
```

---

## 🛠 Troubleshooting & Known Issues

### ❗ `attribute 'xyz' missing`

Ensure that your `variables.nix` file contains all required attributes. Use a central default like:

```nix
let default = import ../../variables/defaultVariables.nix; in
default // { ... }
```

This ensures every module gets all expected keys.



### 🧨 Module flags not working

Make sure you’re not accidentally shadowing or omitting expected fields:

- Use `default.modules // { ... }` instead of `{}` when overriding
- Use `lib.attrByPath` or `lib.getAttrFromPath` for optional flags

---

### 🔄 Flake not updating correctly

Run:

```bash
nix flake update
rebuild switch --flake .#your-host
```

If you're using `nix-direnv`, reload the shell with `direnv reload`.

---

## 📄 License

This project is licensed under the [MIT License](./LICENSE).
---

> 💬 Feedback, PRs, and questions are always welcome.