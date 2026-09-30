{ lib, markdownPlus, ... }:
{
  programs.nixvim.files."ftplugin/markdown.lua" =
    let
      prefix = markdownPlus.tablePrefix + "d";
      inherit (markdownPlus) bind localGroup;
    in
    lib.mkIf markdownPlus.enable {
      keymaps = [
        (bind {
          key = prefix + "r";
          plug = "TableDeleteRow";
          desc = "Delete row";
        })

        (bind {
          key = prefix + "c";
          plug = "TableDeleteColumn";
          desc = "Delete column";
        })
      ];

      extraConfigLua = localGroup prefix "Delete" "";
    };
}
