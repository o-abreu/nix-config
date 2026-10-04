{
  config,
  lib,
  ...
}: let
  inherit (config.programs.nixvim.plugins) which-key dap-ui;
  cfg = config.programs.nixvim.plugins.dap;
  prefix = "<leader>d";
  filetypes = cfg.lazyLoad.settings.ft or [];
  oneShot = cmd: "function() require('dap').${cmd}() end";

  conditionalBreakpoint =
    # lua
    ''
      function()
        vim.ui.input({ prompt = "Condition: "}, function(condition)
          if condition then require('dap').set_breakpoint(condition) end
        end)
      end
    '';

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

  bind = {
    key,
    action,
    desc,
    mode ? "n",
  }: {
    inherit key mode;
    action.__raw = action;
    options = {
      # INFO: `buffer = true`, never `<buffer>` inside `key`. Nixvim does not
      # parse the marker and would emit a *global* map with a literal
      # `<buffer>...` lhs.
      buffer = true;
      inherit desc;
    };
  };

  keymaps =
    [
      # --- Execution ---
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

      # --- Stepping ---
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

      # --- Breakpoints ---
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

      # -- Diagnostics --
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
    ]
    ++ lib.optionals dap-ui.enable [
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
in {
  programs.nixvim = {
    files =
      map (ft: "ftplugin/${ft}.lua") filetypes
      |> lib.flip lib.genAttrs (_: {
        keymaps = lib.mkIf cfg.enable keymaps;
        extraConfigLua =
          lib.mkIf (cfg.enable && which-key.enable)
          ''
            require("which-key").add({
              {
                "${prefix}",
                group = "Debugger",
                mode = { "n", "v" },
                buffer = true,
              },
            })
          '';
      });

    assertions = [
      {
        assertion = !cfg.enable || filetypes != [];
        message = ''
          programs.nixvim.plugins.dap is enabled but no filetype declares a DAP
          adapter, so no ftplugin received the debugger keybinds. Declare
          `plugins.dap.lazyLoad.settings.ft` in the module that adds the adapter
          (see home/features/programs/cli/nixvim/plugins/language-support/python/default.nix).
        '';
      }
    ];
  };
}
