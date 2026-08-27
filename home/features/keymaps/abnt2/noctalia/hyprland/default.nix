{ config, lib, ... }:
let
  # INFO: `SUPER` is the canonical modifier name used in key combos;
  # `SUPER_L` is the physical key used for the tap-to-enter-hyprmode bind.
  mod = "SUPER";
  leaderKey = "SUPER_L";
  dispatch = cmd: lib.generators.mkLuaInline "hl.dsp.${cmd}";
in
{
  wayland.windowManager.hyprland.settings = {
    config.input.kb_layout = "br";
    bind =
      let
        prefix = "${mod} + ";
      in
      (import ./_launchers {
        inherit
          dispatch
          config
          lib
          prefix
          ;
      })
      ++ (import ./_windows {
        inherit dispatch prefix;
      })
      ++ (import ./_workspaces {
        inherit dispatch lib prefix;
      })
      ++ [
        {
          _args = [
            leaderKey
            (dispatch "submap('hyprmode')")
            { description = "Enter Hyprmode"; }
          ];
        }
      ];
  };

  wayland.windowManager.hyprland.submaps.hyprmode.settings.bind =
    let
      prefix = "";
    in
    (import ./_launchers {
      inherit
        dispatch
        config
        lib
        prefix
        ;
    })
    ++ (import ./_windows {
      inherit dispatch prefix;
    })
    ++ (import ./_workspaces {
      inherit dispatch lib prefix;
    })
    ++ [
      {
        _args = [
          "escape"
          (dispatch "submap('reset')")
          { description = "Exit Hyprmode"; }
        ];
      }
      {
        _args = [
          "catchall"
          (dispatch "submap('reset')")
          { non_consuming = true; }
        ];
      }
    ];
}
