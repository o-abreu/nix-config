{
  wayland.windowManager.hyprland.settings.window_rule =
    let
      media = [
        "^.*celluloid.*$"
        "^.*feh.*$"
      ];
      # TODO: Add screen recorders after being able to use hyprctl to fetch their windows' classes.
    in
    map (m: {
      match.class = m;
      idle_inhibit = "fullscreen";
    }) media;
}
