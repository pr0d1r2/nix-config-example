#!/usr/bin/env bats

setup_file() {
    bats_load_library bats-support
    bats_load_library bats-assert
    REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
    export REPO_ROOT

    export NIX="nix --extra-experimental-features nix-command --extra-experimental-features flakes"

    local nix_system
    nix_system=$($NIX eval --raw --impure --expr builtins.currentSystem)

    case "$nix_system" in
        aarch64-darwin)
            export BUILD_CONFIG=".#darwinConfigurations.macos-arm"
            export HM_USER="developer"
            export RESULT_LINK="$REPO_ROOT/result-darwin"
            $NIX build "${BUILD_CONFIG}.system" --out-link "$RESULT_LINK"
            ;;
        x86_64-linux)
            export BUILD_CONFIG=".#nixosConfigurations.linux"
            export HM_USER="developer"
            export RESULT_LINK="$REPO_ROOT/result-linux"
            $NIX build "${BUILD_CONFIG}.config.system.build.toplevel" --out-link "$RESULT_LINK"
            ;;
        aarch64-linux)
            export BUILD_CONFIG=".#nixosConfigurations.linux-arm"
            export HM_USER="developer"
            export RESULT_LINK="$REPO_ROOT/result-linux-arm"
            $NIX build "${BUILD_CONFIG}.config.system.build.toplevel" --out-link "$RESULT_LINK"
            ;;
        *)
            skip "unsupported platform: $nix_system"
            ;;
    esac
}

setup() {
    bats_load_library bats-support
    bats_load_library bats-assert
    REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
    HM_PREFIX="${BUILD_CONFIG}.config.home-manager.users.${HM_USER}"
}

@test "system derivation builds successfully" {
    [ -L "$RESULT_LINK" ]
}

@test "claude-code package resolves" {
    run $NIX eval --json "${HM_PREFIX}.home.packages"
    assert_success
    assert_output --partial "claude-code"
}
