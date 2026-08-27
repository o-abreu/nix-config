{
  dispatch,
  prefix,
}:
[
  {
    _args = [
      (prefix + "Q")
      (dispatch "window.close()")
      { description = "Close focused window"; }
    ];
  }
  {
    _args = [
      (prefix + "Y")
      (dispatch "window.float({action = 'toggle'})")
      { description = "Toggle floating"; }
    ];
  }
  {
    _args = [
      (prefix + "G")
      (dispatch "group.toggle()")
      { description = "Toggle grouping"; }
    ];
  }
  {
    _args = [
      (prefix + "Z")
      (dispatch "window.fullscreen({action = 'toggle'})")
      { description = "Toggle fullscreen"; }
    ];
  }
  {
    _args = [
      (prefix + "P")
      (dispatch "window.pin()")
      { description = "Toggle window pinning"; }
    ];
  }
  {
    _args = [
      (prefix + "I")
      (dispatch "layout('dwindle')")
      { description = "Toggle split orientation"; }
    ];
  }
]
