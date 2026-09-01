{
  ccedilla,
  dispatch,
  prefix,
}:
let
  move = keybind: direction: [
    keybind
    (dispatch "window.move({direction = '${builtins.substring 0 1 direction}', group_aware = true})")
    { description = "Move window ${direction}"; }
  ];
in
[
  { _args = move (prefix + "SHIFT + J") "left"; }
  { _args = move (prefix + "SHIFT + K") "down"; }
  { _args = move (prefix + "SHIFT + L") "up"; }
  { _args = move (prefix + "SHIFT + ${ccedilla}") "right"; }
  {
    _args = [
      (prefix + "mouse:272")
      (dispatch "window.drag()")
      {
        description = "Drag window";
        mouse = true;
      }
    ];
  }
]
