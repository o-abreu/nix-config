{
  wayland.windowManager.hyprland.settings = {
    config.animations.enabled = true;
    curve._args = [
      "myBezier"
      {
        type = "bezier";
        points = [
          [
            0.05
            0.09
          ]
          [
            0.1
            1.05
          ]
        ];
      }
    ];
    animation = [
      {
        leaf = "windows";
        enabled = true;
        speed = 7.0;
        bezier = "myBezier";
      }
      {
        leaf = "windowsOut";
        enabled = true;
        speed = 7.0;
        bezier = "default";
        style = "popin 80%";
      }
      {
        leaf = "border";
        enabled = true;
        speed = 10.0;
        bezier = "default";
      }
      {
        leaf = "borderangle";
        enabled = true;
        speed = 8.0;
        bezier = "default";
      }
      {
        leaf = "fade";
        enabled = true;
        speed = 7.0;
        bezier = "default";
      }
      {
        leaf = "workspaces";
        enabled = true;
        speed = 8.0;
        bezier = "default";
      }
    ];
  };
}
