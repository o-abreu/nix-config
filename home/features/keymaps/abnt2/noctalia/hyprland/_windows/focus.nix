{
  ccedilla,
  dispatch,
  prefix,
}:
let
  focus = keybind: direction: [
    keybind
    (dispatch "focus({direction = '${builtins.substring 0 1 direction}'})")
    { description = "Move window focus ${direction}"; }
  ];
in
[
  { _args = focus (prefix + "J") "left"; }
  { _args = focus (prefix + "K") "down"; }
  { _args = focus (prefix + "L") "up"; }
  { _args = focus (prefix + ccedilla) "right"; }
]
