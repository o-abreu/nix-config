# INFO: This module extends home.file, xdg.configFile and xdg.dataFile with the `mutable` option.
{ ... }:
let
  fileOptionAttrPaths = [
    [
      "home"
      "file"
    ]
    [
      "xdg"
      "configFile"
    ]
    [
      "xdg"
      "dataFile"
    ]
  ];
in
{
  imports = [
    (import ./_options.nix fileOptionAttrPaths)
    (import ./_config.nix fileOptionAttrPaths)
  ];
}
