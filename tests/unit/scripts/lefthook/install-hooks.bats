#!/usr/bin/env bats

setup() {
    bats_load_library bats-support
    bats_load_library bats-assert
    REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../../../.." && pwd)"
    export REPO_ROOT
}

@test "install-hooks.sh exists" {
    [ -f "$REPO_ROOT/scripts/lefthook/install-hooks.sh" ]
}

@test "install-hooks.sh has shebang" {
    run head -1 "$REPO_ROOT/scripts/lefthook/install-hooks.sh"
    assert_output --partial "#!/usr/bin/env bash"
}
