# TODO: Come back after having installed some of Noctalia's plugins, seek feature parity with the launchers we've setup for hydenix.
{
  oneShot,
  prefix,
}:
let
  apostrophe = "code:49";
  panelToggle = "noctalia msg panel-toggle";
in
[
  {
    _args = [
      (prefix + "Space")
      (oneShot "exec_cmd('${panelToggle} launcher')")
      { description = "Application launcher"; }
    ];
  }
  {
    _args = [
      (prefix + "Tab")
      (oneShot "exec_cmd('${panelToggle} window-switcher')")
      { description = "Window switcher"; }
    ];
  }
  {
    _args = [
      (prefix + apostrophe)
      (oneShot "exec_cmd('${panelToggle} session')")
      { description = "Session menu"; }
    ];
  }
]
