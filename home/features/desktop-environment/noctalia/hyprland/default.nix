{ lib, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    settings = {
      on._args = [
        "hyprland.start"
        (lib.generators.mkLuaInline
          # Lua
          ''
            function()
              hl.exec_cmd("noctalia")
            end
          ''
        )
      ];

      config = {
        general = {
          gaps_in = 5;
          gaps_out = 10;
        };

        decoration = {
          rounding = 20;
          rounding_power = 2;

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
          };

          blur = {
            enabled = true;
            size = 3;
            passes = 2;
            vibrancy = 0.1696;
          };
        };

        input = {
          sensitivity = 1.0;
          touchpad.natural_scroll = true;
        };
      };

      monitor = {
        output = "";
        mode = "preferred";
        position = "auto-left";
        scale = 1;
      };
    };
  };
}
