{ lib, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      on._args = [
        "hyprland.start"
        (lib.generators.mkLuaInLine
          # Lua
          ''
            function()
              hl.exec_cmd("noctalia")
            end
          ''
        )
      ];
      monitor = {
        output = "";
        mode = "preferred";
        position = "auto-left";
        scale = 1;
      };
      input.touchpad.natural_scroll = true;
      sensitivity = 1.0;
    };
  };
}
