{
  dispatch,
  prefix,
}:
[
  {
    _args = [
      (prefix + "G")
      (dispatch "group.toggle()")
      { description = "Toggle grouping"; }
    ];
  }
  {
    _args = [
      (prefix + "Left")
      (dispatch "group.prev()")
      { description = "Change active group backwards"; }
    ];
  }
  {
    _args = [
      (prefix + "Right")
      (dispatch "group.next()")
      { description = "Change active group forwards"; }
    ];
  }
]
