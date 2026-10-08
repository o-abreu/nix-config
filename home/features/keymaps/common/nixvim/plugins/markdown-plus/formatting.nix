{
  lib,
  markdownPlus,
  ...
}: {
  programs.nixvim.files = with markdownPlus;
    filetypes
    |> map (ft: "ftplugin/${ft}.lua")
    |> lib.flip lib.genAttrs (_:
      lib.mkIf enable {
        keymaps = [
          (bind {
            key = prefix + "b";
            plug = "Bold";
            mode = ["n" "x"];
            desc = "Toggle bold formatting";
          })

          (bind {
            key = prefix + "i";
            plug = "Italic";
            mode = ["n" "x"];
            desc = "Toggle italic formatting";
          })

          (bind {
            key = prefix + "S";
            plug = "Strikethrough";
            mode = ["n" "x"];
            desc = "Toggle strikethrough formatting";
          })

          (bind {
            key = prefix + "=";
            plug = "Highlight";
            mode = ["n" "x"];
            desc = "Toggle highlight formatting";
          })

          (bind {
            key = prefix + "u";
            plug = "Underline";
            mode = ["x"];
            desc = "Toggle underline formatting";
          })

          (bind {
            key = prefix + "F";
            plug = "ClearFormatting";
            mode = ["x"];
            desc = "Clear all formatting";
          })

          (bind {
            key = prefix + "e";
            plug = "EscapeSelection";
            mode = ["x"];
            desc = "Escape/unescape markdown punctuation in selection";
          })

          (bind {
            key = prefix + "-";
            plug = "InsertThematicBreak";
            desc = "Insert thematic break below";
          })

          (bind {
            key = prefix + "/";
            plug = "CycleThematicBreak";
            desc = "Cycle thematic break style";
          })

          (bind {
            key = prefix + "q";
            plug = "ToggleQuote";
            desc = "Toggle blockquote";
            mode = ["n" "x"];
          })

          (bind {
            key = prefix + "x";
            plug = "ToggleCheckbox";
            desc = "Toggle checkbox";
            mode = ["n" "x"];
          })
        ];
      });
}
