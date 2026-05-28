# SPEC

## §G GOAL

**example repo** — one flake closure to rule all architectures and OS.
builds & passes CI as-is, but intended as starting point you fork
and personalize for your org/machine.
single `flake.nix` defines macOS ARM + Linux x86_64 + Linux ARM —
same inputs, same overlays, same home-manager modules across all three.
w/ nix flakes, home-manager, Claude Code via nix-home-manager-claude-code.
ships working defaults; adopter replaces username, hostname, git identity,
adds org-specific home-manager modules, adjusts Claude Code presets.
one closure, three platforms, zero drift

## §C CONSTRAINTS

- nix flakes only. state version 25.11
- nixpkgs-unstable for select overlays
- 3 platforms: aarch64-darwin, x86_64-linux, aarch64-linux
- 3 generic machine configs: macos-arm, linux, linux-arm
- username parameterized in flake.nix (fork and change)
- hostnames are placeholders — adopter renames to real machines
- `home/users/developer.nix` is example identity — adopter creates own `{username}.nix`
- `home/modules/claude-code.nix` ships sane defaults —
  adopter tunes model, presets, env
- claude-code config via nix-home-manager-claude-code module
- repo ! build & evaluate out of box before any personalization
- shell formatting: shfmt. nix formatting: nixfmt
- no shell function defs in scripts (lefthook enforced)
- test files ! mirror source tree: `scripts/lefthook/foo.sh` → `tests/unit/scripts/lefthook/foo.bats`
- commit messages: imperative, concise
- ASCII only in source (flake.lock excluded)
- narrow-language spell check ∀ staged files
- CI ! evaluate all 3 configs + build darwin + linux + linux-arm
- CI uses nix-lefthook-ci-action for lefthook checks → 3 builds in parallel
- no org-specific or private tooling in template

## §I INTERFACES

- cmd: `nix develop` | `direnv` → dev shell w/ all tools + lefthook hooks auto-installed
- cmd: `bash build.sh` → nix build darwin config → `result-darwin` symlink
- cmd: `darwin-rebuild switch --flake .` → apply darwin config
- cmd: `sudo nixos-rebuild switch --flake .` → apply NixOS config
- cmd: `just test` → `bats --recursive tests/unit`
- cmd: `just lint` → `lefthook run pre-commit`
- cmd: `just fmt` → nixfmt ∀ .nix files
- cmd: `just eval-all` → evaluate all 3 configs (no build)
- cmd: `just switch` → `darwin-rebuild switch --flake .`
- file: `flake.nix` → darwinConfigurations, nixosConfigurations, devShells
- file: `lefthook.yml` → pre-commit (parallel) + pre-push (parallel)
- file: `home/users/{username}.nix` → per-user git identity
- file: `home/modules/claude-code.nix` → Claude Code declarative config
- file: `.narrow-language-*.dic` → per-language word lists
- env: `BATS_LIB_PATH` → bats test libraries path (set by dev shell)

## §V INVARIANTS

V1: ∀ .nix file → `deadnix` clean & `nixfmt` formatted & `statix check` pass
V2: ∀ .sh file → `shellcheck` pass & `shfmt` formatted & no function defs
V3: ∀ committed file → ASCII only (except flake.lock)
V4: `nix eval .#darwinConfigurations.macos-arm.system` ! succeed
V5: `nix eval .#nixosConfigurations.linux.config.system.build.toplevel` ! succeed
V6: `nix eval .#nixosConfigurations.linux-arm.config.system.build.toplevel` ! succeed
V7: CI green: nix-lefthook-ci-action checks pass → all 3 configs build
V8: ∀ hook script → executable bit set
V9: install-hooks.sh ! idempotent (no duplicate lines on re-run)
V10: git hooks ! honor `LEFTHOOK=0` env var to disable
V11: Claude Code config deployed after
`darwin-rebuild switch` or `nixos-rebuild switch`
V12: fork workflow: change username+hostname in flake.nix, add user .nix file, done
V13: repo ! build & evaluate w/ zero changes (example defaults work out of box)
V14: personalization ! not break existing invariants (V1–V11 hold after fork customization)

## §T TASKS

id|status|task|cites
T1|x|scaffold flake w/ darwin + nixos configs (3 platforms)|-
T2|x|add home-manager w/ parameterized username|V12
T3|x|add claude-code module via nix-home-manager-claude-code|V11
T4|x|add lefthook w/ 30+ remote hooks|V1,V2,V3
T5|x|add dev shell w/ all tools + ci devShell (no shellHook)|V4,V5,V6
T6|x|add install-hooks.sh w/ direnv fallback|V8,V9,V10
T7|x|add CI: nix-lefthook-ci-action → 3 parallel builds|V7
T8|x|add unit + integration tests|V4,V5,V6
T9|x|add justfile task runner|-
T10|x|write CLAUDE.md + README|V12
T11|x|write SPEC.md|-
T12|x|wait for nix-home-manager-claude-code CI green, generate flake.lock|V11
T13|x|clean stale follows, verify zero warnings|V4,V5,V6
T14|x|verify all 3 configs evaluate locally|V4,V5,V6,V13
T15|.|verify CI green on GitHub after push|V7
T16|.|set branch protection on main|V7

## §B BUGS

id|date|cause|fix
