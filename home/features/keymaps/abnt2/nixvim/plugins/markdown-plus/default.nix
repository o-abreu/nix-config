{ lib, markdownPlus, ... }:
{
  programs.nixvim.files =
    let
      inherit (markdownPlus) bind tablePrefix localGroup;
    in
    lib.mkIf markdownPlus.enable {
      "lua/mdplus/tablenav.lua".extraConfigLua = builtins.readFile ./tablenav/init.lua;

      "ftplugin/markdown.lua" = {
        keymaps = [
          {
            key = "<M-j>";
            action.__raw = "function() require('mdplus.tablenav').left() end";
            mode = "i";
            options = {
              buffer = true;
              silent = true;
              desc = "Table: cell left, else resize window left";
            };
          }
          {
            key = "<M-k>";
            action.__raw = "function() require('mdplus.tablenav').down() end";
            mode = "i";
            options = {
              buffer = true;
              silent = true;
              desc = "Table: cell down, else resize window down";
            };
          }
          {
            key = "<M-l>";
            action.__raw = "function() require('mdplus.tablenav').up() end";
            mode = "i";
            options = {
              buffer = true;
              silent = true;
              desc = "Table: cell up, else resize window up";
            };
          }
          {
            key = "<M-;>";
            action.__raw = "function() require('mdplus.tablenav').right() end";
            mode = "i";
            options = {
              buffer = true;
              silent = true;
              desc = "Table: cell right, else resize window right";
            };
          }

          (bind {
            key = tablePrefix + "mk";
            plug = "TableMoveRowDown";
            desc = "Move row down";
          })

          (bind {
            key = tablePrefix + "ml";
            plug = "TableMoveRowUp";
            desc = "Move row up";
          })

          (bind {
            key = tablePrefix + "mj";
            plug = "TableMoveColumnLeft";
            desc = "Move column left";
          })

          (bind {
            key = tablePrefix + "mç";
            plug = "TableMoveColumnRight";
            desc = "Move column right";
          })
        ];

        extraConfigLua = localGroup (tablePrefix + "m") "Move" "";
      };
    };
}
