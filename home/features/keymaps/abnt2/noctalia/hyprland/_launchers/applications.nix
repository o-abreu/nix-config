# TODO: Come back after having installed some of Noctalia's plugins, seek feature parity with the launchers we've setup for hydenix.
{
  config,
  lib,
  oneShot,
  prefix,
}:
let
  inherit (config.home) sessionVariables;
  inherit (lib) optional;
in
optional (sessionVariables ? TERMINAL) {
  _args = [
    (prefix + "T")
    (oneShot "exec_cmd('${sessionVariables.TERMINAL}')")
    { description = "Terminal"; }
  ];
}

++ optional (sessionVariables ? BROWSER) {
  _args = [
    (prefix + "B")
    (oneShot "exec_cmd('${sessionVariables.BROWSER}')")
    { description = "Browser"; }
  ];
}

++ optional (sessionVariables ? FILEBROWSER) {
  _args = [
    (prefix + "E")
    (oneShot "exec_cmd('${sessionVariables.FILEBROWSER}')")
    { description = "File browser"; }
  ];
}
