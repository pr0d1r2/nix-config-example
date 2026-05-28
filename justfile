# nix-config-example task runner

# List available recipes
default:
    @just --list

# Build darwin config
build:
    nix --extra-experimental-features 'nix-command flakes' build ".#darwinConfigurations.macos-arm.system" -o result-darwin

# Check for unused Nix bindings
deadnix:
    deadnix .

# Build + dry-run activate
dry-run: build
    sudo ./result-darwin/activate --dry-run

# Evaluate all configurations (no build)
eval-all:
    nix --extra-experimental-features 'nix-command flakes' eval .#darwinConfigurations.macos-arm.system --json >/dev/null
    nix --extra-experimental-features 'nix-command flakes' eval .#nixosConfigurations.linux.config.system.build.toplevel --json >/dev/null
    nix --extra-experimental-features 'nix-command flakes' eval .#nixosConfigurations.linux-arm.config.system.build.toplevel --json >/dev/null

# Format all Nix files
fmt:
    find . -name '*.nix' -not -path './result-*' | xargs nixfmt

# Format all shell files
fmt-sh:
    find . -name '*.sh' -not -path './result-*' | xargs shfmt -w

# Run all linters (via lefthook pre-commit hooks)
lint:
    lefthook run pre-commit

# Check Nix anti-patterns
statix:
    find . -name '*.nix' -not -path './result-*' -exec statix check {} +

# Apply darwin config
switch:
    darwin-rebuild switch --flake .

# Run all unit tests
test:
    bats --recursive tests/unit

# Run a single test file
test-file file:
    bats "{{ file }}"

# Run all unit tests (failures-only output)
test-quiet:
    lefthook-bats-failures-only --recursive --jobs $(nproc) tests/unit

# Run spell checker
typos:
    typos

# Update flake inputs
update:
    nix --extra-experimental-features 'nix-command flakes' flake update
