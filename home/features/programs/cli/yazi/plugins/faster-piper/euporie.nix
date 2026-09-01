{ lib, pkgs, ... }: {
  programs.yazi.settings.plugin = {
    prepend_preloaders = [
      {
        url = "*.ipynb";
        run = "faster-piper -- ${lib.getExe pkgs.python3Packages.euporie} \"$1\"";
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
