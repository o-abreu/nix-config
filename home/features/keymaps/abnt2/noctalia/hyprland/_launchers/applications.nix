# TODO: Come back after having installed some of Noctalia's plugins, seek feature parity with the launchers we've setup for hydenix.
{
  config,
  lib,
  oneShot,
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
      (oneShot "exec_cmd('${sessionVariables.TERMINAL}')")
      { description = "Terminal"; }
    ];
  }
]
++ optionals (sessionVariables ? BROWSER) [
  {
    _args = [
      (prefix + "B")
      (oneShot "exec_cmd('${sessionVariables.BROWSER}')")
      { description = "Browser"; }
    ];
  }
]
++ optionals (sessionVariables ? FILEBROWSER) [
  {
    _args = [
      (prefix + "E")
      (oneShot "exec_cmd('${sessionVariables.FILEBROWSER}')")
      { description = "File browser"; }
    ];
  }
]
