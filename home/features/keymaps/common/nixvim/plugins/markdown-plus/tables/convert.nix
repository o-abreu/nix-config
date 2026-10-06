{
  lib,
  markdownPlus,
  ...
}: {
  programs.nixvim.files = let
    prefix = markdownPlus.tablePrefix + "v";
    inherit (markdownPlus) bind localGroup;
  in
    with markdownPlus;
      filetypes
      |> map (ft: "ftplugin/${ft}.lua")
      |> lib.flip lib.genAttrs (_:
        lib.mkIf enable {
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

          extraConfigLua = localGroup prefix "Convert" "󰈇";
        });
}
