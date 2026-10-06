{
  dap,
  lib,
  ...
}: let
  conditionalBreakpoint =
    # lua
    ''
      function()
        vim.ui.input({ prompt = "Condition: "}, function(condition)
          if condition then require('dap').set_breakpoint(condition) end
        end)
      end
    '';
in {
  programs.nixvim.files =
    dap.filetypes
    |> map (ft: "ftplugin/${ft}.lua")
    |> lib.flip lib.genAttrs (_: {
      keymaps = with dap; [
        (bind {
          key = "<F9>";
          action = oneShot "toggle_breakpoint";
          desc = "Debugger: Toggle Breakpoint";
        })

        (bind {
          key = prefix + "b";
          action = oneShot "toggle_breakpoint";
          desc = "Toggle Breakpoint (F9)";
        })

        (bind {
          key = "<F21>";
          action = conditionalBreakpoint;
          desc = "Debugger: Conditional Breakpoint";
        })

        (bind {
          key = prefix + "B";
          action = conditionalBreakpoint;
          desc = "Conditional Breakpoint (S-F9)";
        })
      ];
    })
    |> lib.mkIf dap.enable;
}
