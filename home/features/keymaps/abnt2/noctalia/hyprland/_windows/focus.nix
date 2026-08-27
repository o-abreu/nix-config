{
  ccedilla,
  dispatch,
  prefix,
}:
[
  {
    _args = [
      (prefix + "J")
      (dispatch "focus({direction = 'l'})")
      { description = "Focus left window"; }
    ];
  }
  {
    _args = [
      (prefix + "K")
      (dispatch "focus({direction = 'u'})")
      { description = "Focus window below"; }
    ];
  }
  {
    _args = [
      (prefix + "L")
      (dispatch "focus({direction = 'd'})")
      { description = "Focus window above"; }
    ];
  }
  {
    _args = [
      (prefix + ccedilla)
      (dispatch "focus({direction = 'r'})")
      { description = "Focus right window"; }
    ];
  }
]
