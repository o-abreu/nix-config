{
  ccedilla,
  dispatch,
  prefix,
}:
[
  {
    _args = [
      (prefix + "ALT + J")
      (dispatch "window.resize({x = -30, y = 0})")
      {
        description = "Resize window left";
        repeating = true;
      }
    ];
  }
  {
    _args = [
      (prefix + "ALT + K")
      (dispatch "window.resize({x = 0, y = 30})")
      {
        description = "Resize window down";
        repeating = true;
      }
    ];
  }
  {
    _args = [
      (prefix + "ALT + L")
      (dispatch "window.resize({x = 0, y = -30})")
      {
        description = "Resize window up";
        repeating = true;
      }
    ];
  }
  {
    _args = [
      (prefix + "ALT + ${ccedilla}")
      (dispatch "window.resize({x = 30, y = 0})")
      {
        description = "Resize window right";
        repeating = true;
      }
    ];
  }
  {
    _args = [
      (prefix + "ALT + mouse:272")
      (dispatch "window.resize()")
      {
        description = "Hold to resize window";
        mouse = true;
      }
    ];
  }
]
