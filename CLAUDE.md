# nix-config-example

One flake closure to rule all architectures and OS.
Cross-platform dev env template - macOS ARM (nix-darwin) & Linux x86_64/ARM (NixOS).
Single flake.nix, same inputs, same modules, three platforms, zero drift.

## Structure

```
flake.nix              # Flake entry: darwinConfigurations, nixosConfigurations, devShells
hosts/darwin/          # nix-darwin system config (macOS ARM)
hosts/linux/           # NixOS system config (x86_64 + aarch64)
home/users/            # home-manager per-user modules (default.nix + per-username)
home/modules/          # home-manager feature modules (claude-code)
nix/dev/shell.sh       # shellHook for nix develop
scripts/lefthook/      # Git hook helper scripts
tests/unit/            # BATS unit tests
tests/integration/     # Integration build tests
```

## Dev environment

```bash
nix develop            # Enter dev shell (or use direnv via .envrc)
```

Dev shell provides all tools: lefthook, bats, deadnix, nixfmt, statix, shellcheck, shfmt, yamllint, typos, hunspell, custom lefthook scripts from remote repos.

Git hooks auto-install by `nix/dev/shell.sh` on shell entry.

## Machines

| Config | System | Hostname |
|--------|--------|----------|
| `darwinConfigurations.macos-arm` | aarch64-darwin | macos-arm |
| `nixosConfigurations.linux` | x86_64-linux | linux |
| `nixosConfigurations.linux-arm` | aarch64-linux | linux-arm |

## Build & apply

```bash
bash build.sh                        # Build darwin config (result-darwin symlink)
darwin-rebuild switch --flake .       # Apply darwin config
sudo nixos-rebuild switch --flake .   # Apply NixOS config
```

## Testing

```bash
bats --recursive tests/unit                     # Run all unit tests
bats tests/unit/build.bats                      # Run a single test file
lefthook-bats-failures-only --recursive tests/unit  # Failures-only output
```

Tests use bats-support, bats-assert, bats-file libraries (`$BATS_LIB_PATH`).

## Linting

All linters run auto via lefthook on pre-commit/pre-push. Manual:

```bash
deadnix .              # Find unused Nix bindings
nixfmt *.nix           # Format Nix files
statix check file.nix  # Nix anti-pattern linter
shellcheck script.sh   # Shell linter
shfmt -d script.sh     # Shell formatter check
yamllint .             # YAML linter
typos                  # Spell checker
```

## Conventions

- Nix formatting: nixfmt
- Shell formatting: shfmt
- No shell function defs in scripts (lefthook enforced)
- Test files mirror source tree: `scripts/lefthook/foo.sh` -> `tests/unit/scripts/lefthook/foo.bats`
- Commit messages: imperative, concise
