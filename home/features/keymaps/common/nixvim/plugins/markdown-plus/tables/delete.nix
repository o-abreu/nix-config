{
  lib,
  markdownPlus,
  ...
}: {
  programs.nixvim.files = let
    prefix = markdownPlus.tablePrefix + "d";
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
        });
}
