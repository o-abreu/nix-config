{ lib, markdownPlus, ... }:
{
  programs.nixvim.files."ftplugin/markdown.lua" =
    let
      prefix = markdownPlus.tablePrefix;
      inherit (markdownPlus) bind localGroup;
    in
    lib.mkIf markdownPlus.enable {
      keymaps = [
        (bind {
          key = prefix + "c";
          plug = "TableCreate";
          desc = "Create new table";
        })

        (bind {
          key = prefix + "f";
          plug = "TableFormat";
          desc = "Format table";
        })

        (bind {
          key = prefix + "n";
          plug = "TableNormalize";
          desc = "Normalize table";
        })

        (bind {
          key = prefix + "a";
          plug = "TableToggleCellAlignment";
          desc = "Cycle cell alignment (left/center/right)";
        })

        (bind {
          key = prefix + "x";
          plug = "TableClearCell";
          desc = "Clear cell content";
        })

        (bind {
          key = prefix + "b";
          plug = "TableInsertBreak";
          desc = "Insert <br> line break at cursor inside cell";
        })

        (bind {
          key = prefix + "w";
          plug = "TableWrapCell";
          desc = "Wrap cell content at word boundaries using <br>";
        })

        (bind {
          key = prefix + "W";
          plug = "TableUnwrapCell";
          desc = "Unwrap cell (strip every <br> variant)";
        })

        (bind {
          key = prefix + "e";
          plug = "TableEditCell";
          desc = "Edit cell content in a floating popup";
        })

        (bind {
          key = prefix + "t";
          plug = "TableTranspose";
          desc = "Transpose table (swap rows/columns)";
        })
      ];

      extraConfigLua = localGroup prefix "Table" "";
    };
}
