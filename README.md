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
    - `variables.nix`

3. Your `variables.nix` should follow this structure:

```nix
{
  username = "freddy";
  host = "default";
  system = "x86_64-linux";
  stateVersion = "25.05";
  modules = {
    console = {
      fish = true;
    };
    driver = {
      nvidia = false;
      amdgpu = false;
    };
    gui = {
      gnome = true;
    };
    software = {
      display-link = false;
      docker = true;
      flatpak = false;
      git = true;
      noisetorch = true;
      wine = false;
      vscode = true;
    };
    systemSettings = {
      bootanimation = true;
      gaming = false;
      printer = true;
      virtualization = false;
    };
  };
  git = {
    lfs = true;
    extraConfig = {
      defaultBranch = "main";
      credential-helper = "store";
    };
    credentials = {
      email = "31123359+Sandbox-Freddy@users.noreply.github.com";
      name = "Sandbox-Freddy";
    };
    includes = [];
  };
  gnome = {
    fav-icon = [
    ];
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