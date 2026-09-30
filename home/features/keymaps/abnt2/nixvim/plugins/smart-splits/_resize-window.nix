{ bind }:
map
  (
    m:
    m
    // {
      mode = [
        "n"
        "i"
        "x"
        "t"
      ];
    }
  )
  [
    (bind "<M-j>" "resize_left" "Push vertical split left")
    (bind "<M-k>" "resize_down" "Push horizontal split down")
    (bind "<M-l>" "resize_up" "Push horizontal split up")
    (bind "<M-;>" "resize_right" "Push vertical split up")
  ]
