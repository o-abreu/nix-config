{
  lib,
  markdownPlus,
  ...
}: {
  programs.nixvim.files = let
    prefix = markdownPlus.prefix + "f";
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
              plug = "FootnoteInsert";
              desc = "Insert footnote";
            })

            (bind {
              key = prefix + "e";
              plug = "FootnoteEdit";
              desc = "Edit footnote";
            })

            (bind {
              key = prefix + "d";
              plug = "FootnoteDelete";
              desc = "Delete footnote";
            })

            (bind {
              key = prefix + "g";
              plug = "FootnoteGotoDefinition";
              desc = "Go to footnote definition";
            })

            (bind {
              key = prefix + "r";
              plug = "FootnoteGotoReference";
              desc = "Go to footnote reference";
            })

            (bind {
              key = prefix + "n";
              plug = "FootnoteNext";
              desc = "Next footnote";
            })

            (bind {
              key = prefix + "p";
              plug = "FootnotePrev";
              desc = "Previous footnote";
            })

            (bind {
              key = prefix + "l";
              plug = "FootnoteList";
              desc = "List footnotes";
            })
          ];

          extraConfigLua = localGroup prefix "Footnotes" "";
        });
}
