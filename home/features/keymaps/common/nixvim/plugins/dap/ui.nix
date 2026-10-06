{
  dap,
  lib,
  ...
}: let
  evalInput =
    # lua
    ''
      function()
        vim.ui.input({ prompt = "Expression: " }, function(expr)
          if expr == nil then
            return
          elseif expr == "" then
            require("dapui").eval()
          else
            require("dapui").eval(expr)
          end
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
          key = prefix + "e";
          action = evalInput;
          desc = "Evaluate Input";
        })

        (bind {
          key = prefix + "e";
          action = "function() require('dapui').eval() end";
          mode = "v";
          desc = "Evaluate Selection";
        })

        (bind {
          key = prefix + "u";
          action = "function() require('dapui').toggle() end";
          desc = "Toggle Debugger UI";
        })
      ];
    })
    |> lib.mkIf (dap.enable && dap.ui.enable);
}
