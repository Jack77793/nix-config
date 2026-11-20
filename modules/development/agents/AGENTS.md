# Global Agent Instructions

## Environment

- OS: Declarative **NixOS** (non-FHS, immutable `/nix/store`, `nix-command` and `flakes` enabled, legacy channels disabled).
- Filesystem: Root `/` may be an ephemeral `tmpfs` (`impermanence`); keep persistent work inside the approved workspace and avoid filling `/` or `/tmp` with large files.
- Shell & runtime: Standard POSIX/bash/zsh environment. Unpatched dynamically-linked prebuilt binaries typically do not run directly on NixOS.

## Nix & Tooling

- **No imperative system installs**: Never run commands that mutate global system state (e.g., `nix-env -i`, `pip install`, `npm install -g`, `curl | bash`, `make install`).
- **Ephemeral & project environments**: When a command or toolchain is missing, prefer the project's `flake.nix` / `shell.nix` (`nix develop` / `nix-shell`), or run ephemerally via `nix run nixpkgs#<pkg>` / `nix shell nixpkgs#<pkg>`. For language-level dependencies, use isolated environments (`uv` with Nix-provided Python, or `pnpm`). If still unavailable, stop and ask the user.
- **NixOS lookup**: Prefer the configured `nixos` MCP server (`mcp-nixos`) to verify NixOS/Home Manager options and package names instead of guessing.
- **No store scans**: Never run `find`, `grep`, or `rg` over `/nix/store`, `/nix`, or `/`.
- **Safe verification**: For Nix/IaC changes, prefer read-only evaluation and checks (`nix flake check`, `nix eval`, `nix build`) and project task runners (`make`, `just`); do not run system switches (`nixos-rebuild switch`, etc.) unless explicitly requested.

## Core Principles

- **Priority**: Follow runtime system instructions > user request > project-local instructions (`AGENTS.md`/`CLAUDE.md`) > this file.
- **Boundaries & safety**: Stay within the approved workspace; never commit or expose secrets; do not run destructive/force commands (`rm -rf`, `--force`, `git reset --hard`) or remote-mutating actions (`git push`, remote `gh` writes, remote deployments) unless explicitly requested.
- **Change hygiene**: Keep edits minimal, scoped, and reviewable; do not revert unrelated changes; never claim verification you did not run.
- **Communication**: Reply concisely in the user's language (English/Chinese); write code, commands, identifiers, and comments in English.
