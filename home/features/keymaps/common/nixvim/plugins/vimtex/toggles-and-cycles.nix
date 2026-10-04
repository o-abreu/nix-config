{
  lib,
  vimtex,
  ...
}:
{
  programs.nixvim.files."ftplugin/tex.lua".keymaps =
    let
      prefix = vimtex.prefix + "u";
      inherit (vimtex) bind;
    in
    lib.mkIf vimtex.enable [
      (bind {
        key = prefix + "$";
        plug = "env-toggle-math";
        desc = "Cycle inline, display & numbered equation";
      })

      (bind {
        key = prefix + "c";
        plug = "cmd-toggle-star";
        desc = "Toggle star of command";
      })

      (bind {
        key = prefix + "f";
        plug = "cmd-toggle-frac";
        mode = [ "n" "x" ];
        desc = "Toggle a/b vs \\frac{a}{b}";
      })

      (bind {
        key = prefix + "b";
        plug = "cmd-toggle-break";
        desc = "Toggle line break";
      })

      (bind {
        key = prefix + "s";
        plug = "env-toggle-star";
        desc = "Toggle starred environment";
      })

      (bind {
        key = prefix + "e";
        plug = "env-toggle";
        desc = "Toggle environment";
      })

      (bind {
        key = prefix + "d";
        plug = "delim-toggle-modifier";
        mode = [ "n" "x" ];
        desc = "Cycle (), \\left(\\right) [, ...]";
      })

      (bind {
        key = prefix + "D";
        plug = "delim-toggle-modifier-reverse";
        mode = [ "n" "x" ];
        desc = "Reverse cycle (), \\left(\\right) [, ...]";
      })
    ];
}
