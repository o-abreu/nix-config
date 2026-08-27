#TODO: Key F9 was left unmapped. find an useful binding for it. System monitor?
{
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland.settings.bind =
    let
      common = {
        locked = true;
        submap_universal = true;
      };
      exec = cmd: lib.generators.mkLuaInline "hl.dsp.exec_cmd('${cmd}')";
      prtSc = "code:107";
    in
    [
      {
        _args = [
          "XF86Sleep"
          (exec "noctalia msg nightlight-toggle")
          ({ description = "Toggle the night light filter"; } // common)
        ];
      }
      {
        _args = [
          "XF86MonBrightnessDown"
          (exec "noctalia msg brightness-down")
          (
            {
              repeating = true;
              description = "Lower monitor brightness";
            }
            // common
          )
        ];
      }
      {
        _args = [
          "XF86MonBrightnessUp"
          (exec "noctalia msg brightness-up")
          (
            {
              repeating = true;
              description = "Increase monitor brightness";
            }
            // common
          )
        ];
      }
      {
        _args = [
          "XF86Display"
          (exec "${osConfig.programs.hyprland.mirrorToggle.package}")
          ({ description = "Toggle mirrored/extended display"; } // common)
        ];
      }
      {
        _args = [
          "XF86TouchpadToggle"
          (exec "${osConfig.programs.hyprland.touchpadToggle.package}")
          ({ description = "Toggle touchpad on/off"; } // common)
        ];
      }
      {
        _args = [
          "XF86AudioMute"
          (exec "noctalia msg volume-mute")
          ({ description = "Mute audio"; } // common)
        ];
      }
      {
        _args = [
          "XF86AudioLowerVolume"
          (exec "noctalia msg volume-down")
          (
            {
              repeating = true;
              description = "Lower audio volume";
            }
            // common
          )
        ];
      }
      {
        _args = [
          "XF86AudioRaiseVolume"
          (exec "noctalia msg volume-up")
          (
            {
              repeating = true;
              description = "Raise audio volume";
            }
            // common
          )
        ];
      }
      {
        _args = [
          "SHIFT + XF86AudioMute"
          (exec "noctalia msg mic-mute")
          ({ description = "Mute the microphone"; } // common)
        ];
      }
      {
        _args = [
          "SHIFT + XF86AudioLowerVolume"
          (exec "noctalia msg mic-volume-down")
          (
            {
              repeating = true;
              description = "Lower microphone volume";
            }
            // common
          )
        ];
      }
      {
        _args = [
          "SHIFT + XF86AudioRaiseVolume"
          (exec "noctalia msg mic-volume-up")
          (
            {
              repeating = true;
              description = "Raise microphone volume";
            }
            // common
          )
        ];
      }
      {
        _args = [
          "F10"
          (exec "${lib.getExe pkgs.impala}")
          ({ description = "Open network menu"; } // common)
        ];
      }
      {
        _args = [
          "F11"
          (exec "noctalia msg power-cycle")
          ({ description = "Change power profile"; } // common)
        ];
      }
      {
        _args = [
          "F12"
          (exec "noctalia msg caffeine-toggle")
          ({ description = "Toggle caffeine mode"; } // common)
        ];
      }
      {
        _args = [
          prtSc
          (exec "noctalia msg screenshot-fullscreen")
          ({ description = "Screenshot the screen of the current monitor"; } // common)
        ];
      }
      {
        _args = [
          "SHIFT + ${prtSc}"
          (exec "noctalia msg screenshot-region")
          ({ description = "Screenshot a selection of the screen"; } // common)
        ];
      }
      {
        _args = [
          "ALT_L + ${prtSc}"
          (exec "noctalia msg screenshot-fullscreen-all")
          ({ description = "Screenshot the screens of all monitors"; } // common)
        ];
      }
      {
        _args = [
          "XF86PowerOff"
          (exec "noctalia msg session lock-and-suspend")
          ({ description = "Suspend the system"; } // common)
        ];
      }
    ];
}
