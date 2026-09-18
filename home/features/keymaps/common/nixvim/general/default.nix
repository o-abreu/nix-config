{ lib, options, ... }:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim.keymaps = [
      {
        action = "<cmd>w<cr>";
        key = "<Leader>w";
        options = {
          desc = "Save file";
        };
        mode = "n";
      }

      {
        action = "<cmd>confirm q<cr>";
        key = "<Leader>q";
        options = {
          desc = "Close window";
        };
        mode = "n";
      }

      {
        action = "<cmd>confirm qall<cr>";
        key = "<Leader>Q";
        options = {
          desc = "Quit Nixvim";
        };
        mode = "n";
      }

      {
        # Trailing space opens the command line in edit mode so the user can
        # name a new file or open an existing one.
        action = "<cmd>e <cr>";
        key = "<Leader>n";
        options = {
          desc = "New/Open file";
        };
        mode = "n";
      }

      {
        action = ">gv";
        key = ">";
        options.desc = "Indent selection";
        mode = "v";
      }

      {
        action = "<gv";
        key = "<";
        options.desc = "Dedent selection";
        mode = "v";
      }

      {
        action = "^y$";
        key = "yy";
        options.desc = "Yank line";
        mode = "n";
      }

      {
        key = "<leader>O";
        action = "<cmd>only<CR>";
        options = {
          desc = "Close all other windows";
        };
        mode = "n";
      }

      {
        action = ":sort<cr>";
        key = "<leader>S";
        options.desc = "Sort";
        mode = "v";
      }

      {
        mode = "i";
        key = "<C-H>";
        action.__raw = ''
          function()
            ${builtins.readFile ./init.lua}
          end
        '';
        options.desc = "Delete preceding whitespace";
      }
    ];
  };
}
