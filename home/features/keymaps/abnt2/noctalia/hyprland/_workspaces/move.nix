{
  count,
  dispatch,
  prefix,
  workspaceKey,
}:
(map (n: {
  _args = [
    (prefix + "SHIFT + ${workspaceKey n}")
    (dispatch "window.move({ workspace = ${toString n} })")
    { description = "Move to workspace ${toString n}"; }
  ];
}) count)
++ [
  # Move window
  {
    _args = [
      (prefix + "SHIFT + S")
      (dispatch "window.move({ workspace = 'special' })")
      { description = "Move to scratchpad"; }
    ];
  }

  # Move window | Relative workspace
  {
    _args = [
      (prefix + "SHIFT + A")
      (dispatch "window.move({ workspace = 'r-1' })")
      { description = "Move window to previous relative workspace"; }
    ];
  }
  {
    _args = [
      (prefix + "SHIFT + F")
      (dispatch "window.move({ workspace = 'r+1' })")
      { description = "Move window to next relative workspace"; }
    ];
  }
  {
    _args = [
      (prefix + "SHIFT + D")
      (dispatch "window.move({ workspace = 'empty' })")
      { description = "Move to nearest empty workspace"; }
    ];
  }
]
