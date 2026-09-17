{ lib, options, ... }:
let
  prefix = "gc";
in
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim.keymaps = [
      {
        action = prefix + "c";
        key = "<leader>/";
        mode = "n";
        options = {
          desc = "Toggle comment line";
          remap = true;
          silent = true;
        };
      }

      {
        action = prefix;
        key = "<leader>/";
        mode = [
          "n"
          "x"
        ];
        options = {
          desc = "Toggle comment";
          remap = true;
          silent = true;
        };
      }

      {
        action = "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";
        key = prefix + "o";
        options = {
          desc = "Insert comment after";
          silent = true;
        };
        mode = "n";
      }

      {
        action = "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";
        key = prefix + "O";
        options = {
          desc = "Insert comment before";
          silent = true;
        };
        mode = "n";
      }
    ];
  };
}
