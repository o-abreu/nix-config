{
  lib,
  vimtex,
  ...
}:
{
  programs.nixvim.files."ftplugin/tex.lua".keymaps =
    let
      inherit (vimtex) bind prefix;
    in
    lib.mkIf vimtex.enable [
      (bind {
        key = prefix + "i";
        plug = "info";
        desc = "Show Info";
      })

      (bind {
        key = prefix + "I";
        plug = "info-full";
        desc = "Show Full Info";
      })

      (bind {
        key = prefix + "t";
        plug = "toc-open";
        desc = "Open Table of Contents";
      })

      (bind {
        key = prefix + "T";
        plug = "toc-toggle";
        desc = "Toggle Table of Contents";
      })

      (bind {
        key = prefix + "q";
        plug = "log";
        desc = "Show VimTeX Log";
      })

      (bind {
        key = prefix + "v";
        plug = "view";
        desc = "View Compiled Document";
      })

      (bind {
        key = prefix + "l";
        plug = "compile";
        desc = "Compile";
      })

      (bind {
        key = prefix + "L";
        plug = "compile-selected";
        mode = [
          "n"
          "x"
        ];
        desc = "Compile Selection";
      })

      (bind {
        key = prefix + "S";
        plug = "compile-ss";
        desc = "Single-shot Compile";
      })

      (bind {
        key = prefix + "k";
        plug = "stop";
        desc = "Stop VimTeX";
      })

      (bind {
        key = prefix + "K";
        plug = "stop-all";
        desc = "Stop All VimTeX";
      })

      (bind {
        key = prefix + "e";
        plug = "errors";
        desc = "Show Errors";
      })

      (bind {
        key = prefix + "o";
        plug = "compile-output";
        desc = "Show Compiler Output";
      })

      (bind {
        key = prefix + "g";
        plug = "status";
        desc = "Show Status";
      })

      (bind {
        key = prefix + "G";
        plug = "status-all";
        desc = "Show Status for All";
      })

      (bind {
        key = prefix + "c";
        plug = "clean";
        desc = "Clean";
      })

      (bind {
        key = prefix + "C";
        plug = "clean-full";
        desc = "Full Clean";
      })

      (bind {
        key = prefix + "m";
        plug = "imaps-list";
        desc = "Show Imaps";
      })

      (bind {
        key = prefix + "x";
        plug = "reload";
        desc = "Reload VimTeX";
      })

      (bind {
        key = prefix + "X";
        plug = "reload-state";
        desc = "Reload VimTeX State";
      })

      (bind {
        key = prefix + "s";
        plug = "toggle-main";
        desc = "Toggle Main";
      })

      (bind {
        key = prefix + "a";
        plug = "context-menu";
        desc = "Show Context Menu";
      })
    ];
}
