{ bind }:
map
  (
    m:
    m
    // {
      mode = [
        "n"
        "x"
      ];
    }
  )
  [
    (bind "J" "swap_buf_left" "Move cursor to window to the left")
    (bind "K" "swap_buf_down" "Move cursor to the window below")
    (bind "L" "swap_buf_up" "Move cursor to the window above")
    (bind "<S-Ç>" "swap_buf_right" "Move cursor to window to the right")
  ]
