{
  lib,
  markdownPlus,
  ...
}: {
  programs.nixvim.files = let
    prefix = markdownPlus.tablePrefix + "s";
    inherit (markdownPlus) bind localGroup;
  in
    with markdownPlus;
      filetypes
      |> map (ft: "ftplugin/${ft}.lua")
      |> lib.flip lib.genAttrs (_:
        lib.mkIf enable {
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

          extraConfigLua = localGroup prefix "Sort" "󰒿";
        });
}
