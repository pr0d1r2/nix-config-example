#!/usr/bin/env bats

setup_file() {
    bats_load_library bats-support
    bats_load_library bats-assert
    REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
    export REPO_ROOT

    export NIX="nix --extra-experimental-features nix-command --extra-experimental-features flakes"

    local nix_system
    nix_system=$($NIX eval --raw --impure --expr builtins.currentSystem)
    export NIX_SYSTEM="$nix_system"

    $NIX build --out-link "$REPO_ROOT/result"
}

setup() {
    bats_load_library bats-support
    bats_load_library bats-assert
    REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"

    local hm_config
    case "$NIX_SYSTEM" in
        aarch64-darwin) hm_config=".#darwinConfigurations.macos-arm" ;;
        x86_64-linux) hm_config=".#nixosConfigurations.linux" ;;
        aarch64-linux) hm_config=".#nixosConfigurations.linux-arm" ;;
    esac
    HM_PREFIX="${hm_config}.config.home-manager.users.developer"
}

@test "system derivation builds successfully" {
    [ -L "$REPO_ROOT/result" ]
}

@test "claude-code package resolves" {
    run $NIX eval --json "${HM_PREFIX}.home.packages"
    assert_success
    assert_output --partial "claude-code"
}
