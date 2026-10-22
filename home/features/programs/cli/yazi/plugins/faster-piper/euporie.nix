{ lib, pkgs, ... }:
let
  # INFO: euporie 2.10.4 pins `timg~=1.1.6` in its metadata, but nixpkgs
  # bumped timg to 1.2.0 (commit e26a2839, 2026-10-08) without relaxing the
  # pin, which fails euporie's runtime deps check. Give euporie its own
  # timg 1.1.6; drop this once euporie or nixpkgs supports timg 1.2.0.
  euporie =
    let
      timg116 = pkgs.python312Packages.timg.overridePythonAttrs (old: rec {
        version = "1.1.6";
        src = pkgs.python312Packages.fetchPypi {
          inherit (old) pname;
          inherit version;
          hash = "sha256-k42TmsNQIwD3ueParfXaD4jFuG/eWILXO0Op0Ci9S/0=";
        };
      });
    in
      pkgs.python312Packages.euporie.override { timg = timg116; };
in
{
  programs.yazi.settings.plugin = {
    prepend_preloaders = [
      {
        url = "*.ipynb";
        # INFO: Pin to Python 3.12 — euporie's `flatlatex` dependency has no
        # build for the default `python3Packages` (3.14).
        run = "faster-piper -- ${lib.getExe euporie} \"$1\"";
      }
    ];
    prepend_previewers = [
      {
        url = "*.ipynb";
        run = "faster-piper --rely-on-preloader";
      }
    ];
  };
}
