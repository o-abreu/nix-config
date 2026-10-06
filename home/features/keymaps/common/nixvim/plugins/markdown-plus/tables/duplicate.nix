{
  lib,
  markdownPlus,
  ...
}: {
  programs.nixvim.files = let
    prefix = markdownPlus.tablePrefix + "y";
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
              plug = "TableDuplicateRow";
              desc = "Duplicate row";
            })

            (bind {
              key = prefix + "c";
              plug = "TableDuplicateColumn";
              desc = "Duplicate column";
            })
          ];

          extraConfigLua = localGroup prefix "Duplicate" "";
        });
}
