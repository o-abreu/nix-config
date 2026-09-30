{ lib, markdownPlus, ... }: {
  programs.nixvim.files."ftplugin/markdown.lua" =
    let
      prefix = markdownPlus.prefix + "Q";
      inherit (markdownPlus) bind localGroup;
    in
    lib.mkIf markdownPlus.enable {
      keymaps = [
        (bind {
          key = prefix + "i";
          plug = "InsertImageCallout";
          desc = "Insert/wrap callout";
        })

        (bind {
          key = prefix + "t";
          plug = "ToggleCalloutType";
          desc = "Toggle callout type";
        })

        (bind {
          key = prefix + "c";
          plug = "ConvertToCallout";
          desc = "Convert blockquote to callout";
        })

        (bind {
          key = prefix + "b";
          plug = "ConvertToBlockquote";
          desc = "Convert callout to blockquote";
        })
      ];

      extraConfigLua = localGroup prefix "Callouts" "󰌵";
    };
}
