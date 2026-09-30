{ lib, markdownPlus, ... }: {
  programs.nixvim.files."ftplugin/markdown.lua" =
    let
      prefix = markdownPlus.prefix + "L";
      inherit (markdownPlus) bind localGroup;
    in
    lib.mkIf markdownPlus.enable {
      keymaps = [
        (bind {
          key = prefix + "i";
          plug = "InsertLink";
          desc = "Insert markdown link";
        })

        (bind {
          key = prefix;
          plug = "SelectionToLink";
          mode = "x";
          desc = "Convert selection to link";
        })

        (bind {
          key = prefix + "e";
          plug = "EditLink";
          desc = "Edit link under cursor";
        })

        (bind {
          key = prefix + "r";
          plug = "ConvertToReference";
          desc = "Convert to reference-style link";
        })

        (bind {
          key = prefix + "I";
          plug = "ConvertToInline";
          desc = "Convert to inline link";
        })

        (bind {
          key = prefix + "a";
          plug = "AutoLinkURL";
          desc = "Convert URL to markdown link";
        })

        (bind {
          key = prefix + "p";
          plug = "SmartPaste";
          desc = "Smart paste URL from clipboard as markdown link";
        })

      ];

      extraConfigLua = localGroup prefix "Links" "";
    };
}
