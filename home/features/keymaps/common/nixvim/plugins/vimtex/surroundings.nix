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
        key = "csc";
        plug = "cmd-change";
        desc = "Change surrounding command";
      })

      (bind {
        key = "cse";
        plug = "env-change";
        desc = "Change surrounding environment";
      })

      (bind {
        key = "cs$";
        plug = "env-change-math";
        desc = "Change surrounding math zone";
      })

      (bind {
        key = "csd";
        plug = "delim-change-math";
        desc = "Change surrounding delimiter";
      })

      (bind {
        key = "dsc";
        plug = "cmd-delete";
        desc = "Delete surrounding command";
      })

      (bind {
        key = "dse";
        plug = "env-delete";
        desc = "Delete surrounding environment";
      })

      (bind {
        key = "ds$";
        plug = "env-delete-math";
        desc = "Delete surrounding math zone";
      })

      (bind {
        key = "dsd";
        plug = "delim-delete";
        desc = "Delete surrounding delimiter";
      })
    ];
}
