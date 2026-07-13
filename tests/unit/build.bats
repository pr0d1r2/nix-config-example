#!/usr/bin/env bats

setup() {
    bats_load_library bats-support
    bats_load_library bats-assert
    if [ -n "$BATS_TEST_DIRNAME" ]; then
        REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
    else
        REPO_ROOT="$(pwd)"
    fi
    export REPO_ROOT
    export NIX="nix --extra-experimental-features nix-command --extra-experimental-features flakes"
}

@test "flake.nix exists" {
    [ -f "$REPO_ROOT/flake.nix" ]
}

@test "darwin config evaluates" {
    command -v nix >/dev/null 2>&1 || skip "nix not available"
    run $NIX eval ".#darwinConfigurations.macos-arm.system" --json
    assert_success
}

@test "linux config evaluates" {
    command -v nix >/dev/null 2>&1 || skip "nix not available"
    run $NIX eval ".#nixosConfigurations.linux.config.system.build.toplevel" --json
    assert_success
}

@test "linux-arm config evaluates" {
    command -v nix >/dev/null 2>&1 || skip "nix not available"
    run $NIX eval ".#nixosConfigurations.linux-arm.config.system.build.toplevel" --json
    assert_success
}

@test "shell scripts pass shfmt -i 2 -ci" {
    command -v shfmt >/dev/null 2>&1 || skip "shfmt not available"
    cd "$REPO_ROOT"
    run bash -c 'shfmt -d -i 2 -ci $(git ls-files "*.sh")'
    assert_success
    assert_output ""
}
