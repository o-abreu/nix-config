{
  dap,
  lib,
  ...
}: {
  programs.nixvim.files =
    dap.filetypes
    |> map (ft: "ftplugin/${ft}.lua")
    |> lib.flip lib.genAttrs (_: {
      keymaps = with dap; [
        (bind {
          key = "<F10>";
          action = oneShot "step_over";
          desc = "Debugger: Step Over";
        })
        (bind {
          key = prefix + "o";
          action = oneShot "step_over";
          desc = "Step Over (F10)";
        })

        (bind {
          key = "<F11>";
          action = oneShot "step_into";
          desc = "Debugger: Step Into";
        })
        (bind {
          key = prefix + "i";
          action = oneShot "step_into";
          desc = "Step Into (F11)";
        })

        (bind {
          key = "<F23>";
          action = oneShot "step_out";
          desc = "Debugger: Step Out (S-F11)";
        })
        (bind {
          key = prefix + "O";
          action = oneShot "step_out";
          desc = "Step Out (S-F11)";
        })

        (bind {
          key = prefix + "r";
          action = oneShot "restart_frame";
          desc = "Restart Frame";
        })
      ];
    })
    |> lib.mkIf dap.enable;
}
