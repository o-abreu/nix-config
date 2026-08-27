{
  count,
  dispatch,
  prefix,
  workspaceKey,
}:
(map (n: {
  _args = [
    (prefix + workspaceKey n)
    (dispatch "focus({ workspace = ${toString n} })")
    { description = "Navigate to workspace ${toString n}"; }
  ];
}) count)
++ [
  # Toggle scratchpad
  {
    _args = [
      (prefix + "S")
      (dispatch "workspace.toggle_special(\"\")")
      { description = "Toggle scratchpad"; }
    ];
  }

  # Navigation | Relative workspace
  {
    _args = [
      (prefix + "D")
      (dispatch "focus({ workspace = 'empty' })")
      { description = "Change to nearest empty workspace"; }
    ];
  }
  {
    _args = [
      (prefix + "A")
      (dispatch "focus({ workspace = 'r-1' })")
      { description = "Change active workspace backwards"; }
    ];
  }
  {
    _args = [
      (prefix + "F")
      (dispatch "focus({ workspace = 'r+1' })")
      { description = "Change active workspace forwards"; }
    ];
  }
]
