{ lib, pkgs, ... }: {
  programs.yazi.settings.plugin = {
    prepend_preloaders = [
      {
        url = "*/";
        run = "faster-piper -- ${lib.getExe pkgs.eza} -TL=3 --color=always --icons=always --group-directories-first --no-quotes \"$1\"";
      }
    ];
    prepend_previewers = [
      {
        url = "*/";
        run = "faster-piper --rely-on-preloader";
      }
    ];
  };
}
