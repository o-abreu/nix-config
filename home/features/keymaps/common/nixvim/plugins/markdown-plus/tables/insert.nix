{ lib, markdownPlus, ... }:
{
  programs.nixvim.files."ftplugin/markdown.lua" =
    let
      prefix = markdownPlus.tablePrefix + "i";
      inherit (markdownPlus) bind localGroup;
    in
    lib.mkIf markdownPlus.enable {
      keymaps = [
        (bind {
          key = prefix + "r";
          plug = "TableInsertRowBelow";
          desc = "Insert row below";
        })

        (bind {
          key = prefix + "R";
          plug = "TableInsertRowAbove";
          desc = "Insert row above";
        })

        (bind {
          key = prefix + "c";
          plug = "TableInsertColumnRight";
          desc = "Insert column right";
        })

        (bind {
          key = prefix + "C";
          plug = "TableInsertColumnLeft";
          desc = "Insert column left";
        })
      ];

      extraConfigLua = localGroup prefix "Insert" "";
    };
}
