# Jack77793's NixOS Config

A personal Nix flake for NixOS and macOS (nix-darwin).

> Do not deploy this configuration unchanged. It includes hardware-specific settings.

## Structure

```
.
├── flake.nix              # Flake entry point, defines hosts, inputs and package outputs
├── Makefile               # Convenience targets: buildpkg, rebuild, gc, check, livecd, ...
├── hosts/                 # Per-machine configurations
├── modules/
│   ├── default.nix        # Explicit imports of feature domains
│   ├── base/              # External modules, users, Home Manager and profile defaults
│   ├── platform/          # Boot, hardware, storage, locale and Nix settings
│   ├── networking/        # Network backends and services
│   ├── security/          # Secrets, fingerprint authentication, GPG and KeePassXC
│   ├── desktop/           # Desktop environment, fonts and peripherals
│   ├── terminal/          # Shell, terminal emulators and CLI tools
│   ├── development/       # Git, Neovim, Python and coding agents
│   ├── applications/      # Applications and gaming
│   └── virtualization/    # Podman defaults and QEMU tools
└── pkgs/
    ├── default.nix        # Overlay aggregator
    ├── pkgs.toml          # Package metadata for nvchecker
    ├── overlays/          # Overlay of packages
    └── ...                # Custom packages
```

## Components

| Category             | Desktop NixOS          |
| -------------------- | ---------------------- |
| Desktop Environment  | Gnome (Mutter)         |
| Display Manager      | GDM                    |
| Shell                | Zsh                    |
| Terminal Emulator    | Ghostty                |
| Terminal Multiplexer | Tmux                   |
| Editor               | Neovim                 |
| Browser              | Chromium               |
| Network Manager      | NetworkManager (iwd)   |
| Input Method         | IBus (Rime, Anthy)     |
| Media Player         | mpv, mpd (ncmpcpp)     |
| Filesystem           | tmpfs /, Btrfs on LUKS |
| Secure Boot          | lanzaboote             |

## Secrets

Secrets use [agenix](https://github.com/ryantm/agenix) and the private `mySecrets` flake input. Deployment requires access to that repository.

## References

- [NixOS-CN/NixOS-CN-telegram](https://github.com/NixOS-CN/NixOS-CN-telegram)
- [ryan4yin/nix-config](https://github.com/ryan4yin/nix-config)
- [Ruixi-rebirth/flakes](https://github.com/Ruixi-rebirth/flakes)
- [NixOS & Nix Flakes Book](https://nixos-and-flakes.thiscute.world)
