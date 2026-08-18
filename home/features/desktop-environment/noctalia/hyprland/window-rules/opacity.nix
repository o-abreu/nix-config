{
  wayland.windowManager.hyprland.settings.window_rule =
    let
      transparent = "0.8 0.7 1.0";
    in
    map
      (m: {
        match.class = m;
        opacity = transparent;
      })
      [
        "^org.wezfurlong.wezterm$"
        "^org.pwmt.zathura$"
        "^polkit-gnome-authentication-agent-1$"
        "^nm-applet$"
        "^nm-connection-editor$"
        "^firefox$"
      ];
}
