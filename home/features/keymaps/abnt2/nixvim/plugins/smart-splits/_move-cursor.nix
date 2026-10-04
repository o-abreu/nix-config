{bind}:
map (m: m // {mode = ["n" "i" "x" "t"];})
[
  (bind "<C-j>" "move_cursor_left" "Move cursor to left window")
  (bind "<C-k>" "move_cursor_down" "Move cursor to the window below")
  (bind "<C-l>" "move_cursor_up" "Move cursor to the window above")
  (bind "<C-;>" "move_cursor_right" "Move cursor to right window")
]
