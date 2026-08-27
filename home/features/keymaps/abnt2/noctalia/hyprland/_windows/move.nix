{
  ccedilla,
  dispatch,
  prefix,
}:
[
  {
    _args = [
      (prefix + "SHIFT + J")
      (dispatch "window.move({direction = 'l', group_aware = true})")
      { description = "Move window left"; }
    ];
  }
  {
    _args = [
      (prefix + "SHIFT + K")
      (dispatch "window.move({direction = 'u', group_aware = true})")
      { description = "Move window up"; }
    ];
  }
  {
    _args = [
      (prefix + "SHIFT + L")
      (dispatch "window.move({direction = 'd', group_aware = true})")
      { description = "Move window down"; }
    ];
  }
  {
    _args = [
      (prefix + "SHIFT + ${ccedilla}")
      (dispatch "window.move({direction = 'r', group_aware = true})")
      { description = "Move window right"; }
    ];
  }
  {
    _args = [
      (prefix + "mouse:272")
      (dispatch "window.drag()")
      {
        description = "Hold to move window";
        mouse = true;
      }
    ];
  }
]
