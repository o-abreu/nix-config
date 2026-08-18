{
  wayland.windowManager.hyprland.settings.window_rule =
    map
      (pattern: {
        match = pattern;
        float = true;
      })
      [
        { title = "^Calculator$"; }
        { title = "^Choose Files$"; }
        { title = "^Confirm to replace files$"; }
        { title = "^File Operation Progress$"; }
        { title = "^Save as$"; }
        { class = "^xdg-desktop-portal-gtk$"; }
        { class = "^feh$"; }
      ];
}
