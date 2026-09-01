{ lib, pkgs, ... }:
let
  filetypes = [
    "*.md"
    "*.json"
    "*.csv"
    "*.rst"
  ];
in
{
  programs.yazi.settings.plugin = {
    prepend_preloaders = map (filetype: {
      url = filetype;
      run = "faster-piper -- ${lib.getExe' pkgs.rich-cli "rich"} -j --left --panel=rounded --guides --line-numbers --force-terminal \"$1\"";
    }) filetypes;
    prepend_previewers = map (filetype: {
      url = filetype;
      run = "faster-piper --rely-on-preloader";
    }) filetypes;
  };
}
