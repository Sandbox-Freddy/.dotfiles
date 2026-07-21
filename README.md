# NixOS Configuration

Modular NixOS setup for multiple hosts, built with [Flakes](https://nixos.wiki/wiki/Flakes) and [Home Manager](https://nix-community.github.io/home-manager/).

- **Hosts:** `work`, `freddy-laptop`, `thinclient`
- **Channel:** NixOS 26.05 (stable) + `nixos-unstable` overlay (`pkgs.unstable.*`)
- **Desktop:** GNOME · **Shell:** Fish

## Usage

```bash
git clone https://github.com/Sandbox-Freddy/.dotfiles ~/.dotfiles
sudo nixos-rebuild switch --flake ~/.dotfiles#work   # pick your host
```

Handy aliases (`modules/console/aliases.nix`):

| Alias | Action |
|-------|--------|
| `rebuild` | `nixos-rebuild switch` for the current host |
| `switchnix` | Same, via `nh` |
| `update` | Update `flake.lock` |
| `cleanup` | GC generations older than 3 days |
| `nixfmt` | Format with `alejandra` |

## Layout

```
flake.nix              Inputs + host definitions (mkNixosConfiguration)
configuration.nix      Common settings shared by all hosts
home.nix               Home Manager integration
hosts/<host>/          Per-host config, hardware scan & variables.nix
modules/               Toggleable modules (console, driver, gui,
                       printer, software, system)
variables/             Default variables + module toggles
```

## Configuration

Features are toggled per host in `hosts/<host>/variables.nix`, which overrides
`variables/defaultVariables.nix`. Key variables: `username`, `host`, `system`,
`stateVersion`, and the nested `modules` set (enable/disable each module).

Machine-local, untracked overrides go in `variables/local.nix`.

## License

[MIT](./LICENSE)
