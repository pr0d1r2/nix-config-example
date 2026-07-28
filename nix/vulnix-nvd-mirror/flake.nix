{
  description = "Immutable NVD feed snapshot for vulnix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/a799d3e3886da994fa307f817a6bc705ae538eeb";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      revision = "01f7b0bf7c15714c1ab8675894412b9ed2af9dcf";
      feeds = {
        "2021" = "4ff0ea8a943f24b0bf5781a6f461e6525ed37c450b70a17f3130cf12968d2de2";
        "2022" = "bfbf34e1580d001524c969e7c4b5c5ad9a3a1472d84b395184351062cbc39b7e";
        "2023" = "6753e42739d715aaaceba5ebaeb94582cfdb2a553ae1ca3c2853d1af3c1a0d63";
        "2024" = "5861c1e2789927a242ca56c3f9a3629da1a9d5cb0abf54ce01ebb2011f3b7094";
        "2025" = "fdf5247fdc32b5335885f05b6de2d4d095a169edb3549ae6b9bc79f9ef432158";
        "2026" = "864c98797968b883e82d15c091c522d3ad19d15a6d1871ccab31217722398a0f";
        modified = "8e18a29b7dec5bf4a60e0d9e2abf682d223d28321bb7534be53bb3ea5e92e322";
      };
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          feedFarm = pkgs.linkFarm "nvd-feeds" (
            nixpkgs.lib.mapAttrsToList (
              name: hash:
              let
                filename = "nvdcve-2.0-${name}.json.gz";
              in
              {
                name = filename;
                path = pkgs.fetchurl {
                  name = filename;
                  sha256 = hash;
                  url = "https://raw.githubusercontent.com/pr0d1r2/nix-vulnix-nvd-mirror/${revision}/${filename}";
                };
              }
            ) feeds
          );
          nvd-cache = pkgs.stdenv.mkDerivation {
            pname = "nvd-cache";
            version = builtins.substring 0 12 revision;
            dontUnpack = true;
            nativeBuildInputs = [
              pkgs.curl
              pkgs.python3
              pkgs.vulnix
            ];
            buildPhase = ''
              runHook preBuild
              export HOME=$TMPDIR
              export PYTHONPATH=${pkgs.vulnix}/${pkgs.python3.sitePackages}:${pkgs.python3Packages.makePythonPath pkgs.vulnix.propagatedBuildInputs}
              mkdir -p "$TMPDIR/cache"
              port=$((20000 + $(echo "$NIX_BUILD_TOP" | cksum | cut -d' ' -f1) % 20000))
              python3 ${./serve-feeds.py} ${feedFarm} "$port" &
              server=$!
              trap 'kill "$server"' EXIT
              until curl -sf "http://127.0.0.1:$port/nvdcve-2.0-modified.json.gz" -o /dev/null; do
                sleep 0.2
              done
              python3 ${./populate.py} "http://127.0.0.1:$port/" "$TMPDIR/cache"
              test -s "$TMPDIR/cache/Data.fs"
              runHook postBuild
            '';
            installPhase = ''
              runHook preInstall
              mkdir -p "$out"
              cp "$TMPDIR/cache/Data.fs" "$out/"
              runHook postInstall
            '';
          };
        in
        {
          inherit nvd-cache;
          default = nvd-cache;
        }
      );
    };
}
