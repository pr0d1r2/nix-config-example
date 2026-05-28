#!/usr/bin/env bats

setup() {
    bats_load_library bats-support
    bats_load_library bats-assert
    REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../../../.." && pwd)"
    export REPO_ROOT
}

@test "shell.sh exists" {
    [ -f "$REPO_ROOT/nix/dev/shell.sh" ]
}

@test "shell.sh installs lefthook hooks" {
    run grep -q "install-hooks" "$REPO_ROOT/nix/dev/shell.sh"
    assert_success
}
