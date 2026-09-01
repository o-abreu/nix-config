{
  ccedilla,
  dispatch,
  prefix,
}:
let
  resize = keybind: x: y: direction: [
    keybind
    (dispatch "window.resize({x = ${toString x}, y = ${toString y}, relative = true})")
    {
      description = "Resize window ${direction}";
      repeating = true;
    }
  ];
in
[
  { _args = resize (prefix + "ALT + J") (-30) 0 "left"; }
  { _args = resize (prefix + "ALT + K") 0 30 "down"; }
  { _args = resize (prefix + "ALT + L") 0 (-30) "up"; }
  { _args = resize (prefix + "ALT + " + ccedilla) 30 0 "right"; }
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
