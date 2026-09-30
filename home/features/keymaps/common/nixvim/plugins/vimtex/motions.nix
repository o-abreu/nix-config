{
  lib,
  vimtex,
  ...
}:
{
  programs.nixvim.files."ftplugin/tex.lua".keymaps =
    let
      inherit (vimtex) bind;
    in
    lib.mkIf vimtex.enable [
      (bind {
        key = "[/";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Previous start of a LaTeX comment";
      })

      (bind {
        key = "[*";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Previous end of a LaTeX comment";
      })

      (bind {
        key = "[[";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Previous beginning of a section";
      })

      (bind {
        key = "[]";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Previous end of a section";
      })

      (bind {
        key = "[m";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Previous \\begin";
      })

      (bind {
        key = "[M";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Previous \\end";
      })

      (bind {
        key = "[n";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Previous start of a math zone";
      })

      (bind {
        key = "[N";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Previous end of a math zone";
      })

      (bind {
        key = "[r";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Previous \\begin{frame}";
      })

      (bind {
        key = "[R";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Previous \\end{frame}";
      })

      (bind {
        key = "]/";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Next start of a LaTeX comment %";
      })

      (bind {
        key = "]*";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Next end of a LaTeX comment %";
      })

      (bind {
        key = "][";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Next beginning of a section";
      })

      (bind {
        key = "]]";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Next end of a section";
      })

      (bind {
        key = "]m";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Next \\begin";
      })

      (bind {
        key = "]M";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Next \\end";
      })

      (bind {
        key = "]n";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Next start of a math zone";
      })

      (bind {
        key = "]N";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Next end of a math zone";
      })

      (bind {
        key = "]r";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Next \\begin{frame}";
      })

      (bind {
        key = "]R";
        mode = [
          "n"
          "x"
          "o"
        ];
        desc = "Next \\end{frame}";
      })
    ];
}
