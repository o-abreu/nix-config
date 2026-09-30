{ lib, ... }:
{
  programs.nixvim = {
    keymaps = [
      {
        action = "<cmd>w<cr>";
        key = "<Leader>w";
        options.desc = "Save file";
        mode = "n";
      }

      {
        action = "<cmd>confirm q<cr>";
        key = "<Leader>q";
        options.desc = "Close window";
        mode = "n";
      }

      {
        action = "<cmd>confirm qall<cr>";
        key = "<Leader>Q";
        options.desc = "Quit Nixvim";
        mode = "n";
      }

      {
        # INFO: Feed `:e ` (without <CR>) so the command line opens in ":" mode
        # with `:e ` prefilled, letting the user name a new file or open an
        # existing one. A bare `<cmd>e <cr>` would execute `:e` with an empty
        # argument (E32) and flash.
        action.__raw = ''
          function()
            vim.api.nvim_feedkeys(":e ", "n", false)
          end
        '';
        key = "<Leader>n";
        options.desc = "New/Open file";
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
        options.desc = "Close all other windows";
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

    plugins.alpha.dashboardButtons = lib.mkMerge [
      (lib.mkOrder 100 [
        {
          desc = "New/Open file";
          icon = "";
        }
      ])
      (lib.mkOrder 2000 [
        {
          desc = "Quit Nixvim";
          icon = "󰅙";
        }
      ])
    ];
  };
}
