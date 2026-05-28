#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"
    REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
    export REPO_ROOT
    export NIX="nix --extra-experimental-features nix-command --extra-experimental-features flakes"
}

@test "flake.nix exists" {
    [ -f "$REPO_ROOT/flake.nix" ]
}

@test "darwin config evaluates" {
    run $NIX eval ".#darwinConfigurations.macos-arm.system" --json
    assert_success
}

@test "linux config evaluates" {
    run $NIX eval ".#nixosConfigurations.linux.config.system.build.toplevel" --json
    assert_success
}

@test "linux-arm config evaluates" {
    run $NIX eval ".#nixosConfigurations.linux-arm.config.system.build.toplevel" --json
    assert_success
}
