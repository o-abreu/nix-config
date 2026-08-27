{
  count,
  dispatch,
  prefix,
  workspaceKey,
}:
(map (n: {
  _args = [
    (prefix + "ALT + ${workspaceKey n}")
    (dispatch "window.move({ workspace = ${toString n}, follow = false })")
    { description = "Send window to workspace ${toString n}"; }
  ];
}) count)
++ [
  # Move window silently
  {
    _args = [
      (prefix + "ALT + S")
      (dispatch "window.move({ workspace = 'special', follow = false })")
      { description = "Send window to scratchpad"; }
    ];
  }

  # Move window silently | Relative workspace
  {
    _args = [
      (prefix + "ALT + A")
      (dispatch "window.move({ workspace = 'r-1', follow = false })")
      { description = "Send window to previous relative workspace"; }
    ];
  }
  {
    _args = [
      (prefix + "ALT + F")
      (dispatch "window.move({ workspace = 'r+1', follow = false })")
      { description = "Send window to next relative workspace"; }
    ];
  }
  {
    _args = [
      (prefix + "ALT + D")
      (dispatch "window.move({ workspace = 'empty', follow = false })")
      { description = "Move to nearest empty workspace"; }
    ];
  }
]
