{
  lib,
  markdownPlus,
  ...
}: {
  programs.nixvim.files = let
    prefix = markdownPlus.tablePrefix + "i";
    inherit (markdownPlus) bind localGroup;
  in
    with markdownPlus;
      filetypes
      |> map (ft: "ftplugin/${ft}.lua")
      |> lib.flip lib.genAttrs (_:
        lib.mkIf enable {
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
        });
}
