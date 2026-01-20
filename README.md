# ⚙️ NixOS Multi-Host Configuration

This repository contains my modular NixOS system configuration, powered by [Nix Flakes](https://nixos.wiki/wiki/Flakes) and [Home Manager](https://nix-community.github.io/home-manager/).

## 🚀 Features

- **Flake-based**: Reproducible system configurations.
- **Multi-host**: Support for different machines (`work`, `freddy-laptop`, `thinclient`).
- **Modular**: Clean separation of drivers, software, and system settings.
- **Home Manager**: Integrated user-level configuration.
- **Centralized Variables**: Easily toggle features and set system-wide flags via `variables.nix`.

## 🛠️ Stack

- **OS**: NixOS
- **Configuration**: Nix (Flakes)
- **User Management**: Home Manager
- **Shell**: Fish (optional, via modules)
- **Desktop Environment**: GNOME (optional, via modules)

## 🏗️ Getting Started

### Prerequisites

- NixOS installed on your machine.

### Installation

1. Clone the repository into `~/.dotfiles`:

```bash
git clone https://github.com/Sandbox-Freddy/.dotfiles ~/.dotfiles
cd ~/.dotfiles
```

2. Apply configuration for a specific host (e.g., `work`):

```bash
sudo nixos-rebuild switch --flake ~/.dotfiles#work
```

## ⌨️ Scripts & Aliases

The configuration provides several useful shell aliases defined in `modules/console/aliases.nix`:

| Alias | Description |
|-------|-------------|
| `rebuild` | Rebuilds the current host configuration. |
| `update` | Updates the `flake.lock` file. |
| `switchnix` | Switches configuration using `nh` (Nix Helper). |
| `nixfmt` | Formats nix files using `alejandra`. |
| `securebootsign` | Signs boot files for Secure Boot using `sbctl`. |

## ➕ Adding a New Host

1. Create a new folder in `./hosts/`, e.g., `my-laptop`.
2. Add the required files:
    - `configuration.nix`: Host-specific NixOS configuration.
    - `default.nix`: Entry point for the host (usually imports other files).
    - `hardware-configuration.nix`: Generated hardware config.
    - `variables.nix`: Configuration flags for this host.

3. Example `variables.nix`:

```nix
let
  default = import ../../variables/defaultVariables.nix;
in
default // {
  host = "my-laptop";
  modules = default.modules // {
    gui = {
      gnome = true;
    };
    software = default.modules.software // {
      docker = true;
    };
  };
}
```

4. Register the host in `flake.nix`:

```nix
nixosConfigurations = {
  my-laptop = mkNixosConfiguration {
    modules = [ ./hosts/my-laptop ];
    hostVariables = import ./hosts/my-laptop/variables.nix;
  };
};
```

## 📁 Project Structure

- `hosts/`: Host-specific configurations.
- `modules/`: Reusable configuration modules.
    - `console/`: Shell, aliases, and terminal themes.
    - `driver/`: Hardware drivers (Nvidia, AMD).
    - `gui/`: Desktop environments (GNOME).
    - `software/`: Application-specific configurations (Docker, Git, etc.).
    - `system/`: Core system settings (Boot, i18n, Gaming).
- `variables/`: Default configuration values.
- `flake.nix`: Main entry point for the flake.
- `home.nix`: Global Home Manager configuration.
- `configuration.nix`: Common NixOS settings shared by all hosts.

## ⚙️ Environment Variables

This project primarily uses Nix variables defined in `variables.nix` rather than traditional environment variables for system configuration. Key variables include:

- `username`: The primary system user.
- `host`: The hostname.
- `system`: The architecture (e.g., `x86_64-linux`).
- `stateVersion`: The NixOS state version.

## 📄 License

This project is licensed under the [MIT License](./LICENSE).

---

> 💬 Feedback, PRs, and questions are always welcome.