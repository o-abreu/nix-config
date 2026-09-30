{
  lib,
  snacksTerminal,
  ...
}:
let
  # INFO: REPL keymaps resolve their interpreter/job at launch time through the
  # `repl-terminals` Lua module (registered under `files` below), then bind
  # vim-slime to the spawned terminal.
  prefix = snacksTerminal.replPrefix;
  # addGroup =
  replMaps =
    ft:
    snacksTerminal.allLayouts {
      inherit prefix;
      bindSlime = true;
      label = "REPL";
      resolve =
        if ft == "quarto" then
          ''require("repl-terminals").for_current()''
        else
          ''require("repl-terminals").for_lang("${ft}")'';
    }
    |> lib.map (
      m:
      m
      // {
        mode = "n";
        options = m.options // {
          buffer = true;
        };
      }
    );
in
{
  programs.nixvim.files =
    builtins.foldl'
      (
        acc: ft:
        acc
        // {
          "ftplugin/${ft}.lua" = {
            keymaps = replMaps ft;
            extraConfigLua =
              # lua
              ''
                require("which-key").add({
                  {
                    "${prefix}",
                    group = "REPL",
                    icon = "⚡",
                    mode = { "n" },
                    buffer = true,
                  },
                })
              '';
          };
        }
      )

      {
        "lua/repl-terminals.lua".extraConfigLua = builtins.readFile ./repl-terminals/init.lua;
      }

      [
        "python"
        "julia"
        "r"
        "quarto"
      ]
    |> lib.mkIf snacksTerminal.enable;

}
