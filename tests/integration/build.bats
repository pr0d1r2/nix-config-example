#!/usr/bin/env bats

setup_file() {
    bats_load_library bats-support
    bats_load_library bats-assert
    REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
    export REPO_ROOT

    export NIX="nix --extra-experimental-features nix-command --extra-experimental-features flakes"

    case "$(uname -s)-$(uname -m)" in
        Darwin-arm64)
            export BUILD_CONFIG=".#darwinConfigurations.macos-arm"
            export HM_USER="developer"
            $NIX build "${BUILD_CONFIG}.system" --out-link "$REPO_ROOT/result-darwin"
            ;;
        Linux-x86_64)
            export BUILD_CONFIG=".#nixosConfigurations.linux"
            export HM_USER="developer"
            $NIX build "${BUILD_CONFIG}.config.system.build.toplevel" --out-link "$REPO_ROOT/result-linux"
            ;;
        Linux-aarch64)
            export BUILD_CONFIG=".#nixosConfigurations.linux-arm"
            export HM_USER="developer"
            $NIX build "${BUILD_CONFIG}.config.system.build.toplevel" --out-link "$REPO_ROOT/result-linux-arm"
            ;;
        *)
            skip "unsupported platform: $(uname -s)-$(uname -m)"
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
    case "$(uname -s)-$(uname -m)" in
        Darwin-arm64) [ -L "$REPO_ROOT/result-darwin" ] ;;
        Linux-x86_64) [ -L "$REPO_ROOT/result-linux" ] ;;
        Linux-aarch64) [ -L "$REPO_ROOT/result-linux-arm" ] ;;
    esac
}

@test "claude-code package resolves" {
    run $NIX eval --json "${HM_PREFIX}.home.packages"
    assert_success
    assert_output --partial "claude-code"
}
