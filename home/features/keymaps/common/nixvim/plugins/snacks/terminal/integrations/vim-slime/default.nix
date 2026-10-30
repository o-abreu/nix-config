{
  config,
  lib,
  snacksTerminal,
  snacksTerminalKeys,
  ...
}: let
  inherit (config.programs.nixvim.plugins) vim-slime which-key;
  prefix = snacksTerminalKeys.replPrefix;
  # Imported rather than taken from `_module.args`: layout expansion is a
  # keybind concern and this is its only consumer besides the terminal keymaps.
  allLayouts = import ../../_layouts.nix {
    inherit lib;
    inherit (snacksTerminal) toggleTerm;
  };
  replMaps = ft:
    allLayouts {
      inherit prefix;
      bindSlime = true;
      label = "REPL";
      resolve =
        if ft == "quarto"
        then ''require("repl-terminals").for_current()''
        else ''require("repl-terminals").for_lang("${ft}")'';
    }
    |> lib.map (m:
      m
      // {
        mode = "n";
        options = m.options // {buffer = true;};
      });
in {
  programs.nixvim.files =
    builtins.foldl'
    (
      acc: ft:
        acc
        // {
          "ftplugin/${ft}.lua" = {
            keymaps = replMaps ft;
            extraConfigLua =
              lib.mkIf which-key.enable
              # lua
              ''
                require("which-key").add({
                  {
                    "${prefix}",
                    group = "REPL",
                    icon = "⚡",
                    mode = "n" ,
                    buffer = true,
                  },
                })
              '';
          };
        }
    )
    {"lua/repl-terminals.lua".extraConfigLua = builtins.readFile ./repl-terminals/init.lua;}
    [
      "python"
      "julia"
      "r"
      "quarto"
    ]
    |> lib.mkIf (vim-slime.enable && snacksTerminal.enable);
}
