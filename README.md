# ⚙️ NixOS Multi-Host Configuration

This repository contains my modular NixOS system configuration, powered by [Nix Flakes](https://nixos.wiki/wiki/Flakes) and [Home Manager](https://nix-community.github.io/home-manager/).

## 🚀 Features

- **Flake-based**: Reproducible system configurations using NixOS 25.11.
- **Multi-host**: Support for different machines (`work`, `freddy-laptop`, `thinclient`).
- **Modular**: Clean separation of drivers, software, and system settings.
- **Home Manager**: Integrated user-level configuration.
- **Centralized Variables**: Easily toggle features and set system-wide flags via `variables.nix`.
- **Pre-configured Software**: Includes modules for Docker, Git, GNOME, and more.

## 🛠️ Stack

- **OS**: NixOS (Stable 25.11 & Unstable)
- **Configuration**: Nix (Flakes)
- **User Management**: Home Manager
- **Shell**: Fish (via `modules/console/fish.nix`)
- **Desktop Environment**: GNOME (via `modules/gui/gnome.nix`)
- **Package Manager**: Nix

## 🏗️ Getting Started

### Requirements

- NixOS installed on your machine

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
| `rebuild` | Rebuilds the current host configuration using `nixos-rebuild`. |
| `update` | Updates the `flake.lock` file. |
| `switchnix` | Switches configuration using `nh` (Nix Helper). |
| `nixfmt` | Formats nix files using `alejandra`. |
| `securebootsign` | Signs boot files for Secure Boot using `sbctl`. |

## 🧪 Tests

- [ ] TODO: Implement automated NixOS tests for configurations.
- Currently, verification is done manually by running `nixos-rebuild dry-activate`.

## 📁 Project Structure

- `hosts/`: Host-specific configurations.
    - `freddy-laptop/`, `thinclient/`, `work/`: Specific machine setups.
- `modules/`: Reusable configuration modules.
    - `console/`: Shell (Fish), aliases, and terminal themes (Oh-My-Posh).
    - `driver/`: Hardware drivers (Nvidia, AMD).
    - `gui/`: Desktop environments (GNOME).
    - `software/`: Application-specific configurations (Docker, Git, Ollama, etc.).
    - `system/`: Core system settings (Boot, i18n, Gaming, Keybindings).
- `variables/`: Default configuration values.
- `flake.nix`: Main entry point for the flake, defining inputs and host configurations.
- `home.nix`: Global Home Manager configuration.
- `configuration.nix`: Common NixOS settings shared by all hosts.
- `overlays.nix`: Custom Nixpkgs overlays.

## ⚙️ Nix Variables

This project primarily uses Nix variables defined in `variables.nix` rather than traditional environment variables for system configuration. Key variables in `variables/defaultVariables.nix` include:

- `username`: The primary system user (default: `freddy`).
- `host`: The hostname.
- `system`: The architecture (e.g., `x86_64-linux`).
- `stateVersion`: The NixOS state version (currently `25.11`).
- `modules`: A nested attribute set to enable/disable specific modules.

## 📄 License

This project is licensed under the [MIT License](./LICENSE).

---

> 💬 Feedback, PRs, and questions are always welcome.