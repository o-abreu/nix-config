{ lib, pkgs, ... }: {
  programs.yazi.settings.plugin = {
    prepend_preloaders = [
      {
        url = "*.ipynb";
        # INFO: Pin to Python 3.12 — euporie's `flatlatex` dependency has no
        # build for the default `python3Packages` (3.14).
        run = "faster-piper -- ${lib.getExe pkgs.python312Packages.euporie} \"$1\"";
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
