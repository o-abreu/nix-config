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
        key = "ic";
        mode = [ "x" "o" ];
        desc = "LaTeX Command";
      })

      (bind {
        key = "ac";
        mode = [ "x" "o" ];
        desc = "LaTeX Command";
      })

      (bind {
        key = "id";
        mode = [ "x" "o" ];
        desc = "LaTeX Math Delimiter";
      })

      (bind {
        key = "ad";
        mode = [ "x" "o" ];
        desc = "LaTeX Math Delimiter";
      })

      (bind {
        key = "ie";
        mode = [ "x" "o" ];
        desc = "LaTeX Environment";
      })

      (bind {
        key = "ae";
        mode = [ "x" "o" ];
        desc = "LaTeX Environment";
      })

      (bind {
        key = "i$";
        mode = [ "x" "o" ];
        desc = "LaTeX Math Zone";
      })

      (bind {
        key = "a$";
        mode = [ "x" "o" ];
        desc = "LaTeX Math Zone";
      })

      (bind {
        key = "iP";
        mode = [ "x" "o" ];
        desc = "LaTeX Section, Paragraph, ...";
      })

      (bind {
        key = "aP";
        mode = [ "x" "o" ];
        desc = "LaTeX Section, Paragraph, ...";
      })

      (bind {
        key = "im";
        mode = [ "x" "o" ];
        desc = "LaTeX Item";
      })

      (bind {
        key = "am";
        mode = [ "x" "o" ];
        desc = "LaTeX Item";
      })
    ];
}
