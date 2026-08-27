# TODO: Come back after having installed some of Noctalia's plugins, seek feature parity with the launchers we've setup for hydenix.
{
  exec,
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
      (exec "${panelToggle} launcher")
      { description = "Application launcher"; }
    ];
  }
  {
    _args = [
      (prefix + "Tab")
      (exec "${panelToggle} window-switcher")
      { description = "Window switcher"; }
    ];
  }
  {
    _args = [
      (prefix + apostrophe)
      (exec "${panelToggle} session")
      { description = "Session menu"; }
    ];
  }
]
