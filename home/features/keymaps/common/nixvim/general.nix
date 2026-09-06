{
  programs.nixvim.keymaps = [
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
      action = "<cmd>enew<cr>";
      key = "<Leader>n";
      options.desc = "New file";
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
        silent = true;
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
          local col = vim.fn.col('.') - 1
          if col == 0 then return end

          local line = vim.fn.getline('.')
          local left_text = line:sub(1, col)
          local spaces = left_text:match("(%s+)$")

          if spaces then
            local row = vim.fn.line('.') - 1
            vim.api.nvim_buf_set_text(0, row, col - #spaces, row, col, {""})
          end
        end
      '';
      options.desc = "Delete preceding whitespace";
    }
  ];
}
