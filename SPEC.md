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
- file: `lefthook.yml` → parallel pre-commit + serial pre-push
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
T4|x|add lefthook w/ 30+ remote hooks and serialize heavy pre-push checks|V1,V2,V3
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
B1|2026-05-28|6 wrapper inputs missing|add flake inputs
B2|2026-05-28|CI bats needs libraries|use bats.withLibraries
B3|2026-05-28|upstream plain bats bug|use bats directly
B4|2026-07-04|narrow-language-add command missing|skip *-add
B5|2026-07-04|unwhitelisted CVEs in vulnix-scan|add to whitelist
B6|2026-07-04|B5 fix broke dic + line length|update dics, shorten
B7|2026-07-04|bats-failures-only nix-dev-shell-agentic needs $HOME|update input pin
B8|2026-07-04|B4-B7 fixes added words not in dic|add 8 words to dic
B9|2026-07-25|pin update broke flake: nix-lefthook dropped overlays output, upstream inputs renamed|remove nix-lefthook overlay+input, drop stale follows overrides
B10|2026-07-25|nix-lefthook-narrow-language upstream removed packages.default, only exposes packages.setting|reference .setting instead of .default in devShells
B11|2026-07-25|B10 fix insufficient: .setting is a config syncer (sync-setting), not the tool binaries; lefthook-narrow-language/freeze still missing|extract tool packages from upstream devShells.default.nativeBuildInputs instead of using .setting
B12|2026-07-25|shell/bats files use 4-space indent but .editorconfig sets indent_size=2; shfmt reads editorconfig and fails|reformat all .sh and .bats files to 2-space indent via shfmt -w
B13|2026-07-25|CI cachix push 403 on PRs: auth token passed unconditionally causes push attempts that fail on pull_request events|gate cachix-auth-token with github.event_name == 'push' so PRs use read-only cache
B14|2026-07-25|B9-B13 fixes added 20 words to SPEC.md not in .narrow-language-markdown.dic|add missing words to dic
B15|2026-07-25|pin update introduced 7 new unwhitelisted CVEs (bytes, gawk, glib, gzip, idna, patch, util-linux)|add to .vulnix-whitelist-system.toml
B16|2026-07-25|B15 CVE whitelist added gawk/glib/gzip/util-linux to .toml but not to .narrow-language-other.dic|add 4 words (gawk, glib, gzip, util) to dic
B17|2026-07-25|SPEC.md uses CVE not in markdown dic|add cve to markdown dic
B18|2026-07-26|stable ldns and openssh have new CVEs|overlay fixed versions from unstable
B19|2026-07-26|ARM runner flake eval hit default hook timeout|set ARM flake eval and check timeout 120
B20|2026-07-26|case patterns were indented but shfmt requires them aligned with case|align case patterns with case
B21|2026-07-26|B20 added 6 words missing from markdown dic|add missing words to dic
B22|2026-07-26|Darwin flake checks exceeded the 120-second CI timeout|increase Darwin flake check and eval timeout to 300 seconds
B23|2026-07-28|mutable NVD mirror feeds no longer matched hashes pinned by the upstream flake revision|pin the feed snapshot to its immutable gh-pages commit
B24|2026-07-28|mirror fix had inline shell and new words; repeated lefthook inputs made the lock too large|extract shell, update dictionaries, and reuse lock inputs
B25|2026-07-28|NVD mirror changes lacked policy coverage; parallel Nix checks exhausted timeouts; the store cache was read-only|complete coverage, serialize heavy checks, raise timeouts, and make the copied cache writable
B26|2026-08-07|nix-lefthook-editorconfig-checker dropped packages.default; its checker remains in devShells.default|use the checker package from the upstream devShell inputs
B27|2026-08-08|Vulnix requests legacy CVE JSON/XZ feeds while the mirror only served NVD 2.0 JSON/GZip feeds|serve a compatibility conversion from NVD 2.0 feeds to Vulnix's legacy format
B28|2026-08-08|single-threaded local NVD mirror could block vulnix behind a readiness or slow feed request until its 10-second timeout|serve feed requests with a reusable threaded HTTP server
B29|2026-08-08|legacy feed conversion still ran inside each Vulnix request and exceeded its 10-second timeout|precompute legacy feed responses before the mirror readiness probe
B30|2026-08-08|NVD mirror contains records without the id field, but vulnix only skips ValueError|convert missing-id KeyError to ValueError before vulnix parses feeds
B31|2026-08-08|upstream nixfmt reformatted the editorconfig checker binding|apply the current nixfmt layout
B32|2026-08-08|SPEC.md exceeded the generic 8 KiB file-size limit as bug history grew|set an explicit 16 KiB Markdown limit
B33|2026-08-08|narrow-language Markdown check scanned Python files and rejected their vocabulary|scope Markdown and Nix checks to their matching file extensions
B34|2026-08-08|narrow-language glob filtered command selection but {push_files} still passed every file to the Nix checker|filter push-file arguments by extension in the command
B35|2026-08-08|pre-commit Markdown checker ran on every staged file despite its name|scope the command to Markdown files and filter staged-file arguments by extension
B36|2026-08-08|narrow-language dictionaries lacked vocabulary introduced by the mirror compatibility code and CI hook scoping|add the missing words to the matching language dictionaries
B37|2026-08-08|narrow-language Python glob filtered command selection but {push_files} still passed every file to the checker|filter staged and pushed arguments to Python files
