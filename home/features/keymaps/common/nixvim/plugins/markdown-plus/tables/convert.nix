{ lib, markdownPlus, ... }:
{
  programs.nixvim.files."ftplugin/markdown.lua" =
    let
      prefix = markdownPlus.tablePrefix + "v";
      inherit (markdownPlus) bind localGroup;
    in
    lib.mkIf markdownPlus.enable {
      keymaps = [
        (bind {
          key = prefix + "i";
          plug = "TableFromCSV";
          desc = "Convert CSV to table";
        })

        (bind {
          key = prefix + "x";
          plug = "TableToCSV";
          desc = "Convert table to CSV";
        })
      ];

      extraConfigLua = localGroup prefix "Convert" "";
    };
}
