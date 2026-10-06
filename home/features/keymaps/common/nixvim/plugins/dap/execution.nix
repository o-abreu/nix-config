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
          key = "<F5>";
          action = oneShot "continue";
          desc = "Debugger: Start/Continue";
        })

        (bind {
          key = prefix + "c";
          action = oneShot "continue";
          desc = "Start/Continue (F5)";
        })

        (bind {
          key = "<F17>";
          action = oneShot "terminate";
          desc = "Debugger: Stop (S-F5)";
        })

        (bind {
          key = prefix + "Q";
          action = oneShot "terminate";
          desc = "Terminate Session (S-F5)";
        })

        (bind {
          key = prefix + "s";
          action = oneShot "run_to_cursor";
          desc = "Run To Cursor";
        })

        (bind {
          key = prefix + "P";
          action = oneShot "run_last";
          desc = "Run previous debug session";
        })
      ];
    })
    |> lib.mkIf dap.enable;
}
