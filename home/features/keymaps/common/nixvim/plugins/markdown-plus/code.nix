{ lib, markdownPlus, ... }: {
  programs.nixvim.files."ftplugin/markdown.lua" =
    let
      inherit (markdownPlus) prefix bind;
    in
    lib.mkIf markdownPlus.enable {
      keymaps = [
        (bind {
          key = prefix + "`";
          plug = "Code";
          mode = [
            "n"
            "x"
          ];
          desc = "Toggle inline code formatting";
        })

        (bind {
          key = prefix + "c";
          plug = "CodeBlockInsert";
          desc = "Insert/wrap fenced code block with language";
        })

        (bind {
          key = prefix + "w";
          plug = "CodeBlock";
          mode = "x";
          desc = "Convert selection to code block";
        })

        (bind {
          key = prefix + "C";
          plug = "CodeBlockChangeLanguage";
          desc = "Change language of fenced code block";
        })
      ];
    };
}
