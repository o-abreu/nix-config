{ lib, pkgs, ... }: {
  programs.yazi.settings.plugin = {
    prepend_preloaders = [
      {
        url = "*.tar*";
        run = "faster-piper -- ${lib.getExe' pkgs.gnutar "tar"} tf \"$1\"";
      }
    ];
    prepend_previewers = [
      {
        url = "*.tar*";
        run = "faster-piper --rely-on-preloader --format=url";
      }
    ];
  };
}
