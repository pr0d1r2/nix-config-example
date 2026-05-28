# nix-config-example

**One flake closure to rule all architectures and OS.**

Cross-platform Nix dev environment template with Claude Code integration. A single `flake.nix` defines macOS ARM, Linux x86_64, and Linux ARM -- same inputs, same overlays, same home-manager modules across all three. One closure, three platforms, zero drift.

**Builds and passes CI as-is** -- but intended as a starting point you fork and personalize for your org and machines.

Supports **macOS ARM** (nix-darwin), **Linux x86_64** and **Linux ARM** (NixOS).

## Quick start

Works out of the box with `developer` as the default username. To personalize:

1. Fork this repo
2. Edit `flake.nix`: change `username` and `hostname` in your machine config
3. Create `home/users/<your-username>.nix` with your git identity (see `developer.nix` for the pattern)
4. Tune `home/modules/claude-code.nix`: model, thinking budget, presets
5. Add your own home-manager modules under `home/modules/`
6. Run:

```bash
# macOS
darwin-rebuild switch --flake .

# Linux
sudo nixos-rebuild switch --flake .
```

## What you get

- **Nix flakes** with pinned nixpkgs 25.11
- **home-manager** for user-level config (git, zsh, direnv, delta)
- **Claude Code** declaratively configured via [nix-home-manager-claude-code](https://github.com/pr0d1r2/nix-home-manager-claude-code)
- **30+ git hooks** via lefthook (auto-installed on shell entry)
- **Dev shell** with linters, formatters, test tools
- **CI** that evaluates and builds all configurations

## Configurations

| Name | Platform | Use |
|------|----------|-----|
| `macos-arm` | aarch64-darwin | Apple Silicon Mac |
| `linux` | x86_64-linux | x86 Linux / NixOS |
| `linux-arm` | aarch64-linux | ARM Linux (RPi, cloud) |

## Development

```bash
nix develop          # Enter dev shell
just test            # Run tests
just lint            # Run linters
just fmt             # Format Nix files
just eval-all        # Evaluate all configs
```

See [CLAUDE.md](CLAUDE.md) for full documentation.

## License

MIT
