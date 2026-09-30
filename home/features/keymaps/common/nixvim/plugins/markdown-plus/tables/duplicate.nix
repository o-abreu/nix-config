{ lib, markdownPlus, ... }:
{
  programs.nixvim.files."ftplugin/markdown.lua" =
    let
      prefix = markdownPlus.tablePrefix + "y";
      inherit (markdownPlus) bind localGroup;
    in
    lib.mkIf markdownPlus.enable {
      keymaps = [
        (bind {
          key = prefix + "r";
          plug = "TableDuplicateRow";
          desc = "Duplicate row";
        })

        (bind {
          key = prefix + "c";
          plug = "TableDuplicateColumn";
          desc = "Duplicate column";
        })
      ];

      extraConfigLua = localGroup prefix "Duplicate" "";
    };
}
