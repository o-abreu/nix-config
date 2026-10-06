{
  dap,
  lib,
  ...
}: let
  setLogLevel =
    # lua
    ''
      function()
        local levels = { "TRACE", "DEBUG", "INFO", "WARN", "ERROR" }
        vim.ui.select(levels, {
          prompt = "DAP log level: ",
          format_item = function(level)
            return level == "INFO" and (level .. " (default)") or level
          end,
        }, function(choice)
          if choice then require("dap").set_log_level(choice) end
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
          key = prefix + "l";
          action = setLogLevel;
          desc = "Debugger: Set Log Level";
        })

        (bind {
          key = prefix + "R";
          action = oneShot "repl.toggle";
          desc = "Toggle REPL";
        })
      ];
    })
    |> lib.mkIf dap.enable;
}
