# Jack77793's NixOS Config

A personal NixOS configuration flake for multiple hosts.

> **Note:** This configuration contains hardware-specific settings and references a private secrets repository. Do not deploy it directly on your machine — use it as a reference instead.

## Structure

```
.
├── flake.nix              # Flake entry point, defines hosts and inputs
├── Makefile               # Convenience targets: rebuild, gc, check, livecd, ...
├── hosts/                 # Per-machine configurations
├── modules/
│   ├── default.nix        # Module options and profile defaults
│   ├── vars.nix           # Global variables (username, ssh keys, etc.)
│   ├── nixos/
│   │   ├── default.nix    # Entry point, imports agenix, impermanence, lanzaboote modules
│   │   ├── base/          # System-level base configuration
│   │   ├── desktop/       # Desktop-related system config
│   │   └── extras/        # Optional features, enabled per-host
│   └── home/
│       ├── default.nix    # Home-manager entry point
│       ├── base/          # Core home-manager modules
│       ├── cli/           # CLI tools
│       └── gui/           # GUI applications
└── pkgs/
    ├── default.nix        # Overlay aggregator
    ├── pkgs.toml          # Package metadata for nvchecker
    ├── overlays/
    └── ...                # Custom packages
```

## Components

| Category | Desktop NixOS |
|----------|---------------|
| Desktop Environment | Gnome (Mutter) |
| Display Manager | GDM |
| Shell | Zsh |
| Terminal Emulator | Ghostty |
| Terminal Multiplexer | Tmux |
| Editor | Neovim |
| Browser | Chromium |
| Network Manager | NetworkManager (iwd) |
| Input Method | IBus (Rime, Anthy) |
| Media Player | mpv, mpd (ncmpcpp) |
| Filesystem | tmpfs /, Btrfs on LUKS |
| Secure Boot | lanzaboote |

## Secrets Management

Secrets are managed with [agenix](https://github.com/ryantm/agenix) and stored in a private repository, referenced as the `mySecrets` flake input. This configuration cannot be deployed without access to that repository.

## References

- [NixOS-CN/NixOS-CN-telegram](https://github.com/NixOS-CN/NixOS-CN-telegram)
- [ryan4yin/nix-config](https://github.com/ryan4yin/nix-config)
- [Ruixi-rebirth/flakes](https://github.com/Ruixi-rebirth/flakes)
- [NixOS & Nix Flakes Book](https://nixos-and-flakes.thiscute.world)
