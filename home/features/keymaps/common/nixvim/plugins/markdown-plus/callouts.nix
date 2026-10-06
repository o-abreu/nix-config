{
  lib,
  markdownPlus,
  ...
}: {
  programs.nixvim.files =
    let
      prefix = markdownPlus.prefix + "Q";
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
      });
}
