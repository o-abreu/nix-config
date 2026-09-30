{ lib, markdownPlus, ... }: {
  programs.nixvim.files."ftplugin/markdown.lua" =
    let
      prefix = markdownPlus.prefix + "h";
      inherit (markdownPlus) bind localGroup;
    in
    lib.mkIf markdownPlus.enable {
      keymaps = [
        (bind {
          key = prefix + "+";
          plug = "PromoteHeader";
          desc = "Promote header (increase level)";
        })

        (bind {
          key = prefix + "-";
          plug = "DemoteHeader";
          desc = "Demote header (decrease level)";
        })

        (bind {
          key = prefix + "s";
          plug = "ToggleAtxSetext";
          desc = "Toggle heading between ATX and setext style";
        })

        (bind {
          key = prefix + "t";
          plug = "GenerateTOC";
          desc = "Generate table of contents";
        })

        (bind {
          key = prefix + "u";
          plug = "UpdateTOC";
          desc = "Update table of contents";
        })

        (bind {
          key = prefix + "T";
          plug = "OpenTocWindow";
          desc = "Open navigable TOC window";
        })

      ]
      ++ map (
        i:
        (bind {
          key = prefix + (toString i);
          plug = "Header${toString i}";
          desc = "Set/convert to H${toString i}";
        })
      ) (lib.range 1 6);

      extraConfigLua = localGroup prefix "Header/TOC" "";
    };
}
