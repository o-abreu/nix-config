{
  oneShot,
  prefix,
}:
[
  {
    _args = [
      (prefix + "Q")
      (oneShot "window.close()")
      { description = "Close focused window"; }
    ];
  }
  {
    _args = [
      (prefix + "Y")
      (oneShot "window.float({action = 'toggle'})")
      { description = "Toggle floating"; }
    ];
  }
  {
    _args = [
      (prefix + "Z")
      (oneShot "window.fullscreen({action = 'toggle'})")
      { description = "Toggle fullscreen"; }
    ];
  }
  # {
  #   _args = [
  #     (prefix + "P")
  #     (dispatch "window.pin()")
  #     { description = "Toggle window pinning"; }
  #   ];
  # }
  # {
  #   _args = [
  #     (prefix + "I")
  #     (dispatch "layout('dwindle')")
  #     { description = "Toggle split orientation"; }
  #   ];
  # }
]
