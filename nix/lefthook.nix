{ pkgs }:
pkgs.buildGo126Module {
  pname = "lefthook";
  version = "2.1.6";

  src = pkgs.fetchFromGitHub {
    owner = "evilmartians";
    repo = "lefthook";
    rev = "v2.1.6";
    hash = "sha256-thMjOtAAWrKvQDUlJmnvT1QT2CDx42XKlzV+weFsFrA=";
  };

  vendorHash = "sha256-75jrXoBXoPCE/Ue7OlGAA4nUDXHM5ccIaK4rsKgfG84=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  meta = {
    description = "Fast and powerful Git hooks manager for any type of projects";
    homepage = "https://github.com/evilmartians/lefthook";
    license = pkgs.lib.licenses.mit;
    mainProgram = "lefthook";
  };
}
