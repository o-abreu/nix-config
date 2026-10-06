{
  lib,
  markdownPlus,
  ...
}: {
  programs.nixvim.files =
    let
      prefix = markdownPlus.prefix + "I";
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
            plug = "InsertImage";
            desc = "Insert markdown image";
          })

          (bind {
            key = prefix;
            plug = "SelectionToImage";
            desc = "Convert selection to image";
            mode = "x";
          })

          (bind {
            key = prefix + "e";
            plug = "EditImage";
            desc = "Edit image under cursor";
          })

          (bind {
            key = prefix + "t";
            plug = "ToggleImageLink";
            desc = "Toggle between link and image";
          })
        ];

        extraConfigLua = localGroup prefix "Images" "󰉏";
      });
}
