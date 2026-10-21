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

Handy aliases (`rebuild`, `switchnix`, `update`, `cleanup`, `nixfmt`) are defined in
[`modules/console/aliases.nix`](modules/console/aliases.nix).

## Layout

```
flake.nix              Inputs + host definitions (mkNixosConfiguration)
configuration.nix      Common settings shared by all hosts
home.nix               Home Manager integration
hosts/<host>/          Per-host config, hardware scan & variables.nix
modules/               Toggleable modules (console, gui, hardware,
                       software, system)
variables/             Default variables + module toggles
```

## Configuration

Features are toggled per host in `hosts/<host>/variables.nix`, which deep-merges over
`variables/defaultVariables.nix`. Key variables: `username`, `host`, `system`,
`stateVersion`, `dotfilesDir`, and the nested `modules` set of booleans — each one maps
automatically onto `modules.<category>.<name>.enable`.

Settings that are not a simple on/off switch are set directly on the module option in
`hosts/<host>/configuration.nix`, e.g.:

```nix
modules.gui.gnome.favoriteApps = ["firefox.desktop"];
modules.hardware.scanbutton.outputDir = "/mnt/paperless";
```

Machine-local, untracked overrides go in `variables/local.nix` — these require
`--impure`, otherwise they are silently ignored.

## License

[MIT](./LICENSE)
