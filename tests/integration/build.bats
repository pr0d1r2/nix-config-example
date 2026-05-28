#!/usr/bin/env bats

setup_file() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
    REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
    export REPO_ROOT

    export NIX="nix --extra-experimental-features nix-command --extra-experimental-features flakes"
    export DARWIN_CONFIG=".#darwinConfigurations.macos-arm"

    $NIX build "${DARWIN_CONFIG}.system" --out-link "$REPO_ROOT/result-darwin"
}

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
    REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
    HM_PREFIX="${DARWIN_CONFIG}.config.home-manager.users.developer"
}

@test "system derivation builds successfully" {
    [ -L "$REPO_ROOT/result-darwin" ]
    [ -d "$REPO_ROOT/result-darwin" ]
}

@test "claude-code package resolves" {
    run $NIX eval --json "${HM_PREFIX}.home.packages"
    assert_success
    assert_output --partial "claude-code"
}
