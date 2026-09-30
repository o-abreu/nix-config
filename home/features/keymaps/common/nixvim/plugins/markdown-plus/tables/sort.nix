{ lib, markdownPlus, ... }:
{
  programs.nixvim.files."ftplugin/markdown.lua" =
    let
      prefix = markdownPlus.tablePrefix + "s";
      inherit (markdownPlus) bind localGroup;
    in
    lib.mkIf markdownPlus.enable {
      keymaps = [
        (bind {
          key = prefix + "a";
          plug = "TableSortAscending";
          desc = "Sort table by column (ascending)";
        })

        (bind {
          key = prefix + "d";
          plug = "TableSortDescending";
          desc = "Sort table by column (descending)";
        })
      ];

      extraConfigLua = localGroup prefix "Sort" "";
    };
}
