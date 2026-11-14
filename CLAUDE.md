# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A modular NixOS configuration (Nix Flakes + Home Manager) for three hosts: `work`, `freddy-laptop`, `thinclient`. Channel is NixOS 26.05 stable; `nixos-unstable` is available as an overlay via `pkgs.unstable.*`. Desktop is GNOME, shell is Fish. All Nix is formatted with **alejandra**.

## Commands

Aliases live in `modules/console/aliases.nix` (available in the interactive shell on a built system):

| Command | Action |
|---------|--------|
| `rebuild` | `sudo nixos-rebuild switch --flake ~/.dotfiles#<host> --impure` |
| `switchnix` | Same via `nh os switch -H <host> ~/.dotfiles --impure` |
| `update` | `nix flake update` |
| `cleanup` | `sudo nix-collect-garbage --delete-older-than 3d` |
| `nixfmt` | `alejandra ./` — run before committing |

**`--impure` matters only if `variables/local.nix` exists.** `variables/defaultVariables.nix` probes that absolute path with `builtins.pathExists`, which in pure evaluation mode returns `false` instead of erroring — so without `--impure` the local overrides are *silently ignored* rather than failing loudly. CI therefore always builds the un-overridden configuration.

Build a host without switching (this is what CI does — see `.github/workflows/build.yml`, which delegates per-host builds to `.github/actions/build-nix-host`):
```bash
nix build '.#nixosConfigurations."work".config.system.build.toplevel' --impure
# CI uses: nix run nixpkgs#nix-fast-build -- --flake '.#nixosConfigurations."<host>".config.system.build.toplevel' --skip-cached --no-nom --cachix-cache sandbox-freddy-dotfiles
```

Dev shell (provides `alejandra`): `nix develop`

There is no test suite — CI validates by building all three host configurations plus an `alejandra --check .` job. A change is "verified" when the host builds.

Note that the flake reads host files from the **git index**, so a newly created module must be `git add`-ed before it will evaluate.

## Architecture

The flake wires everything together through `mkNixosConfiguration` in `flake.nix`, which for each host imports `configuration.nix` (common settings), the `modules/` tree, Home Manager, and the host's own directory. Host-specific variables are passed to every module as `specialArgs.hostVariables`; `specialArgs.self` is passed alongside it purely so `modules/system/symlink.nix` can map store paths back onto the checkout.

**The variable → toggle → module flow is the core pattern.** Understanding it requires reading these together:

1. `variables/defaultVariables.nix` — all default values plus the nested `modules = { ... }` set of **boolean** toggles, and the `mkHostVariables host moduleOverrides` helper. It deep-merges (in order) the defaults, the host's overrides, and an untracked `variables/local.nix`.
2. `hosts/<host>/variables.nix` — calls `mkHostVariables` with only the toggles that differ from the defaults; nesting is handled by the deep merge, so partial attrsets are fine:
   ```nix
   mkHostVariables "work" { hardware.amdgpu = true; software.python = true; system.ssh = true; }
   ```
3. `configuration.nix` — maps the toggles onto module options generically:
   ```nix
   modules = lib.mapAttrs (_: lib.mapAttrs (_: enable: {inherit enable;})) hostVariables.modules;
   ```
   This only works because every toggle name matches its module path exactly and every value is a boolean. **Keep both invariants.** Non-boolean, per-host module settings do *not* belong in `variables/` — set them directly on the option in `hosts/<host>/configuration.nix` (see `modules.gui.gnome.favoriteApps`, `modules.system.ssh.settings`, `modules.hardware.scanbutton.outputDir`).

**Module convention.** Every feature module (`modules/<category>/<name>.nix`) defines a typed option under `modules.<category>.<name>` and gates its config behind it:
```nix
{ config, lib, pkgs, hostVariables, ... }:
let cfg = config.modules.software.git;
in {
  options.modules.software.git = { enable = lib.mkEnableOption "git"; /* ... */ };
  config = lib.mkIf cfg.enable { /* ... */ };
}
```
`modules/default.nix` imports **every** `.nix` file below itself via `lib.filesystem.listFilesRecursive` — there are no per-category `default.nix` files to maintain. Categories: `console`, `gui`, `hardware`, `software`, `system`. A module that ships data files gets a subdirectory holding `<name>/<name>.nix` next to them; a subdirectory *without* that inner file is a plain data directory owned by another module (`console/oh-my-posh`, read by `console/fish.nix`).

`configuration.nix` asserts that every gated module has a matching toggle, so a module you forget to wire up fails the build by name instead of silently never loading. Modules that are intentionally ungated are listed in `ungatedModules` there. The opposite mistake — a toggle with no module — is already caught by the module system itself.

`modules/console/aliases.nix` and everything under `modules/system/` except `bootanimation.nix` and `ssh.nix` are deliberately *ungated* common settings rather than toggleable features.

User-scoped config goes through Home Manager inside a module's `config` block as `home-manager.users.${hostVariables.username} = { ... };` (see `modules/software/git.nix`).

## Adding things

- **New feature module:** create `modules/<category>/<name>.nix` following the option + `mkIf` convention, add a boolean toggle named exactly `<name>` in `variables/defaultVariables.nix` under `modules.<category>`, and `git add` the file. The import and the toggle mapping are both generic, so nothing else needs touching; skip the toggle and the build tells you. Enable per-host in `hosts/<host>/variables.nix`.
- **Ungated common setting:** same, but skip the toggle and add the path (`<category>/<name>.nix`) to `ungatedModules` in `configuration.nix`.
- **New host:** add `hosts/<host>/` (with `configuration.nix`, `hardware-configuration.nix`, `variables.nix`) and add the name to the `genAttrs` list in `flake.nix` and to `matrix.host` in `.github/workflows/build.yml`. `networking.hostName` and `system.stateVersion` come from the shared `configuration.nix`.

## Windows dual boot and Secure Boot on `freddy-laptop`

Lanzaboote is enabled in the configuration for this host in
[`hosts/freddy-laptop/configuration.nix`](hosts/freddy-laptop/configuration.nix).
A rebuild is required to install its signed boot artifacts; it does not enroll
firmware keys or enable Secure Boot. Other hosts are unaffected. The host
configuration temporarily disables `system.autoUpgrade`. The auto-upgrader uses
the last committed configuration and can reboot; an older commit could reinstall
the unsigned bootloader after Secure Boot has been enabled.

1. Back up the laptop, including its EFI system partition (ESP), and prepare
   bootable NixOS and Windows recovery media. Before changing partitions or
   rebuilding, compare `findmnt /boot`, `findmnt /` and `lsblk -f` on the actual
   laptop with `hosts/freddy-laptop/hardware-configuration.nix`. Resolve any
   mismatch first; do not format or overwrite the NixOS partitions. Rebuild to
   apply the host's declarative `system.autoUpgrade.enable = lib.mkForce false;`
   and keep automatic upgrades paused throughout the migration, including reboots.
2. Windows 11 is installed on the dedicated **Samsung SSD 860 EVO 500GB**
   (currently `/dev/sda`, 465.8 GiB). Its Windows Boot Manager uses the NixOS
   disk's ESP on the Samsung SSD 990 EVO Plus 2TB NVMe, mounted at `/boot`.
   Do **not** delete or format either disk or the shared ESP. Disk numbering can
   change, so verify the layout before making any storage changes. Check that
   both operating systems still start via the firmware boot menu. Keep the
   Windows BitLocker/device-encryption recovery key outside the laptop, even if
   encryption was enabled automatically.
3. Inspect `sudo sbctl status` before creating keys. If no keys exist, run
   `sudo sbctl create-keys`. Store a protected backup of `/var/lib/sbctl`
   outside the Nix store and repository: it contains private signing keys.
4. With Secure Boot temporarily disabled but the firmware keys intact, apply
   the host's Lanzaboote configuration with
   `sudo nixos-rebuild switch --flake ~/.dotfiles#freddy-laptop --impure`.
   Check `sudo sbctl verify` and test that NixOS still boots before changing
   firmware keys. Lanzaboote's documentation explains which unsigned files in
   the verification output are expected.
5. Before modifying firmware trust, check the laptop's UEFI documentation and
   inventory its existing keys. Preserve the Microsoft and required OEM trust
   entries and the `dbx` revocation database. If supported, adding the new public
   db certificate while retaining the existing entries avoids replacing the
   whole key hierarchy. Otherwise the exact enrollment procedure depends on
   the firmware: **do not blindly clear all keys or enroll only your own**.
   If Windows uses BitLocker, suspend its protection for the firmware changes
   and keep the recovery key available; resume protection after both systems
   boot correctly. Never clear the TPM as a troubleshooting shortcut.
6. Enable Secure Boot and verify with `bootctl status` and `sudo sbctl status`.
   Test both operating systems via the firmware boot menu. Depending on the ESP
   layout, Windows may not automatically appear in systemd-boot. Restore
   automatic upgrades only after the working Lanzaboote configuration is
   committed and available to the auto-upgrader.

See the upstream [Lanzaboote setup guide](https://github.com/nix-community/lanzaboote/blob/v1.2.0/docs/getting-started/prepare-your-system.md)
for signing and [firmware guide](https://github.com/nix-community/lanzaboote/blob/v1.2.0/docs/getting-started/enable-secure-boot.md)
for firmware-specific details. Merely turning Secure Boot off is not the same as
entering UEFI Setup Mode; do not enter Setup Mode until the key-preservation plan
for this particular machine is understood.

## Notes

- **Out-of-store config.** `modules/system/symlink.nix` (ungated) provides two `_module.args` every module can take: `mkOutOfStorePath ./x` returns the path of `./x` inside `~/.dotfiles` as a plain string, and `mkSymlink ./x` wraps that in a `home.file` / `xdg.configFile` entry. Both make a file read from the working tree instead of a store snapshot, so edits apply without a rebuild — used by `modules/console/fish.nix` for the oh-my-posh theme. Only worth it for config you iterate on: the link dangles at runtime if the checkout moves, rather than failing the build. Adapted from [modulix](https://github.com/anders130/modulix) (MIT).
- `nix-settings.json` is the single source of truth for `experimental-features`, `substituters`, and `trusted-public-keys`. `modules/system/flakes.nix` reads it into `nix.settings` for every built host, and `.github/actions/setup-nix-cachix` reads the same file (via `jq`) to configure the CI runner's Nix install — update it once, both sides pick it up.
- `nix-prefetch.sh` puts the DisplayLink driver archive into the store (the package is `requireFile`-based); re-run it when the upstream URL changes. Used by `modules/hardware/displaylink.nix`, and run by CI (via `setup-nix-cachix`) before each build.
- `templates/` holds a starter dev-environment flake (`flake.nix` + `.envrc` with `use flake`) for scaffolding per-project `direnv` shells. It has two consumers, so keep it to exactly the files a new project should get: the `templates.default` flake output (`nix flake init -t ~/.dotfiles`, which copies the directory verbatim), and `modules/gui/gnome.nix`, which offers the same two files in Nautilus' "New Document" menu.
- Untracked: `variables/local.nix`, `.direnv`, `.idea` (see `.gitignore`).
