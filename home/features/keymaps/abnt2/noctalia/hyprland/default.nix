{ config, lib, ... }:
let
  inherit (config.lib.stylix) colors;
  lua = lib.generators.mkLuaInline;
  dispatch = cmd: lua "hl.dsp.${cmd}";
  border-cmd =
    color: "hyprctl eval \\\"hl.config({ general = { col = { active_border = 'rgb(${color})' } } })\\\"";
  oneShot =
    cmd:
    lua
      # lua
      ''
        function()
          hl.dispatch(hl.dsp.${cmd})
          hl.dispatch(hl.dsp.exec_cmd("${border-cmd colors.base0D}"))
          hl.dispatch(hl.dsp.submap('reset'))
        end
      '';

  binds =
    prefix:
    (import ./_launchers {
      inherit
        config
        lib
        oneShot
        prefix
        ;
    })
    ++ (import ./_windows {
      inherit dispatch oneShot prefix;
    })
    ++ (import ./_workspaces {
      inherit dispatch lib prefix;
    });
in
{
  wayland.windowManager.hyprland = {
    settings = {
      config.input.kb_layout = "br";
      bind =
        # INFO: `SUPER` is the canonical modifier name used in key combos;
        # `SUPER_L` is the physical key used for the tap-to-enter-hyprmode bind.
        (binds "SUPER + ") ++ [
          {
            _args = [
              "SUPER_L"
              (lua
                # lua
                ''
                  function()
                    hl.dispatch(hl.dsp.exec_cmd("${border-cmd colors.base08}"))
                    hl.dispatch(hl.dsp.submap('hyprmode'))
                  end
                ''
              )
              { description = "Enter Hyprmode"; }
            ];
          }
        ];
    };

    submaps.hyprmode.settings.bind = (binds "") ++ [
      {
        _args = [
          "escape"
          (lua
            # lua
            ''
              function()
                hl.dispatch(hl.dsp.exec_cmd("${border-cmd colors.base0D}"))
                hl.dispatch(hl.dsp.submap('reset'))
              end
            ''
          )
          { description = "Exit Hyprmode"; }
        ];
      }
    ];
  };
}
