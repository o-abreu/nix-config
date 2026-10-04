{ lib, markdownPlus, ... }: {
  programs.nixvim.files."ftplugin/markdown.lua" =
    let
      prefix = markdownPlus.prefix + "l";
      inherit (markdownPlus) bind localGroup;
    in
    lib.mkIf markdownPlus.enable {
      keymaps = [
        (bind {
          key = prefix + "d";
          plug = "DebugLists";
          desc = "Debug list groups";
        })

        (bind {
          key = prefix + "r";
          plug = "RenumberLists";
          desc = "Renumber ordered lists";
        })

        (bind {
          key = prefix + "u";
          plug = "ToggleListUnordered";
          desc = "Toggle unordered list";
          mode = [ "n" "x" ];
        })

        (bind {
          key = prefix + "o";
          plug = "ToggleListOrdered";
          desc = "Toggle ordered list";
          mode = [ "n" "x" ];
        })

        (bind {
          key = prefix + "t";
          plug = "ToggleListTask";
          desc = "Toggle task list";
          mode = [ "n" "x" ];
        })

        (bind {
          key = prefix + "N";
          plug = "ToggleListOrderedParen";
          desc = "Toggle parenthesized ordered list";
          mode = [ "n" "x" ];
        })

        (bind {
          key = prefix + "l";
          plug = "ToggleListLetterLower";
          desc = "Toggle lowercase letter list";
          mode = [ "n" "x" ];
        })

        (bind {
          key = prefix + "L";
          plug = "ToggleListLetterUpper";
          desc = "Toggle uppercase letter list";
          mode = [ "n" "x" ];
        })

        (bind {
          key = prefix + "p";
          plug = "ToggleListLetterLowerParen";
          desc = "Toggle parenthesized lowercase letter list";
          mode = [ "n" "x" ];
        })

        (bind {
          key = prefix + "P";
          plug = "ToggleListLetterUpperParen";
          desc = "Toggle parenthesized uppercase letter list";
          mode = [ "n" "x" ];
        })

        (bind {
          key = prefix + "c";
          plug = "ToggleListClear";
          desc = "Clear list markers (plain text)";
          mode = [ "n" "x" ];
        })
      ];

      extraConfigLua = localGroup prefix "Lists" "";
    };
}
