# TODO: Come back after having installed some of Noctalia's plugins, seek feature parity with the launchers we've setup for hydenix.
{
  exec,
  config,
  lib,
  prefix,
}:
let
  inherit (config.home) sessionVariables;
  inherit (lib) optionals;
in
optionals (sessionVariables ? TERMINAL) [
  {
    _args = [
      (prefix + "T")
      (exec sessionVariables.TERMINAL)
      { description = "Terminal"; }
    ];
  }
]
++ optionals (sessionVariables ? BROWSER) [
  {
    _args = [
      (prefix + "B")
      (exec sessionVariables.BROWSER)
      { description = "Browser"; }
    ];
  }
]
++ optionals (sessionVariables ? FILEBROWSER) [
  {
    _args = [
      (prefix + "F")
      (exec sessionVariables.FILEBROWSER)
      { description = "File browser"; }
    ];
  }
]
