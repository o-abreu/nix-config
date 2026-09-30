{ lib, markdownPlus, ... }: {
  programs.nixvim.files."ftplugin/markdown.lua" =
    let
      prefix = markdownPlus.prefix + "I";
      inherit (markdownPlus) bind localGroup;
    in
    lib.mkIf markdownPlus.enable {
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
    };
}
