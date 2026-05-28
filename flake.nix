{
  description = "Cross-platform dev environment example - macOS (nix-darwin) & Linux (NixOS)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code-nix = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-home-manager-claude-code = {
      url = "github:pr0d1r2/nix-home-manager-claude-code";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-lefthook-trailing-whitespace = {
      url = "github:pr0d1r2/nix-lefthook-trailing-whitespace";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-git-conflict-markers = {
      url = "github:pr0d1r2/nix-lefthook-git-conflict-markers";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-missing-final-newline = {
      url = "github:pr0d1r2/nix-lefthook-missing-final-newline";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-git-no-local-paths = {
      url = "github:pr0d1r2/nix-lefthook-git-no-local-paths";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-nix-no-embedded-shell = {
      url = "github:pr0d1r2/nix-lefthook-nix-no-embedded-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-tcl-syntax = {
      url = "github:pr0d1r2/nix-lefthook-tcl-syntax";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-unicode-lint = {
      url = "github:pr0d1r2/nix-lefthook-unicode-lint";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-no-shell-functions = {
      url = "github:pr0d1r2/nix-lefthook-no-shell-functions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-bats-parse = {
      url = "github:pr0d1r2/nix-lefthook-bats-parse";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-bats-failures-only = {
      url = "github:pr0d1r2/nix-lefthook-bats-failures-only";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-bats-changed = {
      url = "github:pr0d1r2/nix-lefthook-bats-changed";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nix-lefthook-bats-failures-only.follows = "nix-lefthook-bats-failures-only";
      };
    };
    nix-lefthook-taplo = {
      url = "github:pr0d1r2/nix-lefthook-taplo";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-statix = {
      url = "github:pr0d1r2/nix-lefthook-statix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-nix-flake-eval = {
      url = "github:pr0d1r2/nix-lefthook-nix-flake-eval";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-ascii-only = {
      url = "github:pr0d1r2/nix-lefthook-ascii-only";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-vulnix-scan = {
      url = "github:pr0d1r2/nix-lefthook-vulnix-scan";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-unstable.follows = "nixpkgs-unstable";
      };
    };
    nix-lefthook-justfile-alphabetical = {
      url = "github:pr0d1r2/nix-lefthook-justfile-alphabetical";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-commit-msg-lint = {
      url = "github:pr0d1r2/nix-lefthook-commit-msg-lint";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nix-lefthook-unicode-lint.follows = "nix-lefthook-unicode-lint";
      };
    };
    nix-lefthook-editorconfig-checker = {
      url = "github:pr0d1r2/nix-lefthook-editorconfig-checker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-execute-permissions = {
      url = "github:pr0d1r2/nix-lefthook-execute-permissions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nix-lefthook-unicode-lint.follows = "nix-lefthook-unicode-lint";
      };
    };
    nix-lefthook-file-size-check = {
      url = "github:pr0d1r2/nix-lefthook-file-size-check";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nix-lefthook-unicode-lint.follows = "nix-lefthook-unicode-lint";
      };
    };
    nix-lefthook-gitleaks = {
      url = "github:pr0d1r2/nix-lefthook-gitleaks";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-markdownlint = {
      url = "github:pr0d1r2/nix-lefthook-markdownlint";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-linter-coverage = {
      url = "github:pr0d1r2/nix-lefthook-linter-coverage";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nix-lefthook-unicode-lint.follows = "nix-lefthook-unicode-lint";
      };
    };
    nix-lefthook-nix-flake-check = {
      url = "github:pr0d1r2/nix-lefthook-nix-flake-check";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-narrow-language = {
      url = "github:pr0d1r2/nix-lefthook-narrow-language";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-lefthook-tdd-order-bats = {
      url = "github:pr0d1r2/nix-lefthook-tdd-order-bats";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-darwin,
      nixpkgs-unstable,
      nix-darwin,
      home-manager,
      claude-code-nix,
      nix-home-manager-claude-code,
      nix-lefthook-nix-flake-eval,
      nix-lefthook-ascii-only,
      nix-lefthook-trailing-whitespace,
      nix-lefthook-git-conflict-markers,
      nix-lefthook-missing-final-newline,
      nix-lefthook-tcl-syntax,
      nix-lefthook-unicode-lint,
      nix-lefthook-nix-no-embedded-shell,
      nix-lefthook-no-shell-functions,
      nix-lefthook-bats-parse,
      nix-lefthook-bats-failures-only,
      nix-lefthook-bats-changed,
      nix-lefthook-taplo,
      nix-lefthook-statix,
      nix-lefthook-justfile-alphabetical,
      nix-lefthook-vulnix-scan,
      nix-lefthook-commit-msg-lint,
      nix-lefthook-editorconfig-checker,
      nix-lefthook-execute-permissions,
      nix-lefthook-file-size-check,
      nix-lefthook-gitleaks,
      nix-lefthook-markdownlint,
      nix-lefthook-linter-coverage,
      nix-lefthook-nix-flake-check,
      nix-lefthook-narrow-language,
      nix-lefthook-tdd-order-bats,
      ...
    }:
    let
      stateVersion = "25.11";

      userFile =
        username:
        let
          path = ./home/users/${username}.nix;
        in
        if builtins.pathExists path then [ path ] else [ ];

      hmModule =
        { username, homeDirectory }:
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = {
              inherit
                claude-code-nix
                nix-home-manager-claude-code
                ;
            };
            users.${username} =
              { ... }:
              {
                imports = [ ./home/users/default.nix ] ++ userFile username;
                home = {
                  inherit username stateVersion;
                  homeDirectory = nixpkgs.lib.mkForce homeDirectory;
                };
              };
          };
        };

      supportedSystems = [
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
      overlays = [
        (_: prev: {
          direnv = prev.direnv.overrideAttrs { doCheck = false; };
          lefthook = import ./nix/lefthook.nix { pkgs = prev; };
          inherit (nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system}) vulnix;
        })
      ];
      pkgsFor =
        system:
        let
          isDarwin = builtins.match ".*-darwin" system != null;
          src = if isDarwin then nixpkgs-darwin else nixpkgs;
        in
        import src { inherit system overlays; };
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f (pkgsFor system));

      mkDarwin =
        {
          system,
          hostname,
          username,
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit hostname username stateVersion; };
          modules = [
            ./hosts/darwin/default.nix
            {
              nixpkgs.hostPlatform = system;
              nixpkgs.overlays = overlays;
            }
            home-manager.darwinModules.home-manager
            (hmModule {
              inherit username;
              homeDirectory = "/Users/${username}";
            })
          ];
        };

      mkNixos =
        {
          system,
          hostname,
          username,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit hostname username stateVersion; };
          modules = [
            ./hosts/linux/default.nix
            {
              nixpkgs.hostPlatform = system;
              nixpkgs.overlays = overlays;
              networking.hostName = hostname;
            }
            home-manager.nixosModules.home-manager
            (hmModule {
              inherit username;
              homeDirectory = "/home/${username}";
            })
          ];
        };
    in
    {
      # --- macOS (Apple Silicon) ---
      darwinConfigurations."macos-arm" = mkDarwin {
        system = "aarch64-darwin";
        hostname = "macos-arm";
        username = "developer";
      };

      # --- Linux (x86_64) ---
      nixosConfigurations."linux" = mkNixos {
        system = "x86_64-linux";
        hostname = "linux";
        username = "developer";
      };

      # --- Linux (ARM) ---
      nixosConfigurations."linux-arm" = mkNixos {
        system = "aarch64-linux";
        hostname = "linux-arm";
        username = "developer";
      };

      devShells = forAllSystems (
        pkgs:
        let
          sys = pkgs.stdenv.hostPlatform.system;
          batsLibs = pkgs.symlinkJoin {
            name = "bats-libs";
            paths = with pkgs.bats.libraries; [
              bats-support
              bats-assert
              bats-file
            ];
          };
        in
        {
          default = pkgs.mkShell {
            packages = [
              nix-lefthook-nix-flake-eval.packages.${sys}.default
              nix-lefthook-ascii-only.packages.${sys}.default
              nix-lefthook-trailing-whitespace.packages.${sys}.default
              nix-lefthook-git-conflict-markers.packages.${sys}.default
              nix-lefthook-missing-final-newline.packages.${sys}.default
              nix-lefthook-tcl-syntax.packages.${sys}.default
              nix-lefthook-unicode-lint.packages.${sys}.default
              nix-lefthook-nix-no-embedded-shell.packages.${sys}.default
              nix-lefthook-no-shell-functions.packages.${sys}.default
              nix-lefthook-bats-parse.packages.${sys}.default
              nix-lefthook-bats-failures-only.packages.${sys}.default
              nix-lefthook-bats-changed.packages.${sys}.default
              nix-lefthook-taplo.packages.${sys}.default
              nix-lefthook-statix.packages.${sys}.default
              nix-lefthook-justfile-alphabetical.packages.${sys}.default
              nix-lefthook-vulnix-scan.packages.${sys}.default
              nix-lefthook-commit-msg-lint.packages.${sys}.default
              nix-lefthook-editorconfig-checker.packages.${sys}.default
              nix-lefthook-execute-permissions.packages.${sys}.default
              nix-lefthook-file-size-check.packages.${sys}.default
              nix-lefthook-gitleaks.packages.${sys}.default
              nix-lefthook-markdownlint.packages.${sys}.default
              nix-lefthook-linter-coverage.packages.${sys}.default
              nix-lefthook-nix-flake-check.packages.${sys}.default
              nix-lefthook-narrow-language.packages.${sys}.default
              nix-lefthook-tdd-order-bats.packages.${sys}.default
            ]
            ++ (with pkgs; [
              bats
              bats.libraries.bats-assert
              bats.libraries.bats-file
              bats.libraries.bats-support
              parallel
              coreutils
              deadnix
              findutils
              gawk
              gh
              gnugrep
              gnused
              git
              hunspell
              just
              lefthook
              nil
              nixfmt
              nodejs
              ripgrep
              shellcheck
              shfmt
              statix
              typos
              vulnix
              wordnet
              yamllint
            ]);
            BATS_LIB_PATH = "${batsLibs}/share/bats";
            shellHook = builtins.readFile ./nix/dev/shell.sh;
          };

          ci = pkgs.mkShell {
            packages = [
              nix-lefthook-nix-flake-eval.packages.${sys}.default
              nix-lefthook-ascii-only.packages.${sys}.default
              nix-lefthook-trailing-whitespace.packages.${sys}.default
              nix-lefthook-git-conflict-markers.packages.${sys}.default
              nix-lefthook-missing-final-newline.packages.${sys}.default
              nix-lefthook-tcl-syntax.packages.${sys}.default
              nix-lefthook-unicode-lint.packages.${sys}.default
              nix-lefthook-nix-no-embedded-shell.packages.${sys}.default
              nix-lefthook-no-shell-functions.packages.${sys}.default
              nix-lefthook-bats-parse.packages.${sys}.default
              nix-lefthook-bats-failures-only.packages.${sys}.default
              nix-lefthook-bats-changed.packages.${sys}.default
              nix-lefthook-taplo.packages.${sys}.default
              nix-lefthook-statix.packages.${sys}.default
              nix-lefthook-justfile-alphabetical.packages.${sys}.default
              nix-lefthook-vulnix-scan.packages.${sys}.default
              nix-lefthook-commit-msg-lint.packages.${sys}.default
              nix-lefthook-editorconfig-checker.packages.${sys}.default
              nix-lefthook-execute-permissions.packages.${sys}.default
              nix-lefthook-file-size-check.packages.${sys}.default
              nix-lefthook-gitleaks.packages.${sys}.default
              nix-lefthook-markdownlint.packages.${sys}.default
              nix-lefthook-linter-coverage.packages.${sys}.default
              nix-lefthook-nix-flake-check.packages.${sys}.default
              nix-lefthook-narrow-language.packages.${sys}.default
              nix-lefthook-tdd-order-bats.packages.${sys}.default
            ]
            ++ (with pkgs; [
              bats
              bats.libraries.bats-assert
              bats.libraries.bats-file
              bats.libraries.bats-support
              parallel
              coreutils
              deadnix
              findutils
              gawk
              gh
              gnugrep
              gnused
              git
              hunspell
              just
              lefthook
              nil
              nixfmt
              nodejs
              ripgrep
              shellcheck
              shfmt
              statix
              typos
              vulnix
              wordnet
              yamllint
            ]);
            BATS_LIB_PATH = "${batsLibs}/share/bats";
          };
        }
      );
    };
}
