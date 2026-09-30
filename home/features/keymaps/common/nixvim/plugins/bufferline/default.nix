{
  config,
  lib,
  ...
}:
let
  cfg = config.programs.nixvim.plugins.bufferline;
  prefix = "<leader>b";
in
{
  _module.args.bufferline = { inherit cfg prefix; };

  programs.nixvim = {
    plugins = {
      bufferline.settings.options.letter_mapping = "asdfjklçghnmertziopwxcvqb\\-";
      which-key.settings.spec = lib.optional cfg.enable {
        __unkeyed-1 = "<leader>b";
        group = "Buffers";
        icon = "󰓩 ";
      };
    };

    keymaps =
      [
        {
          key = "<Right>";
          action.__raw =
            # lua
            ''
              function()
                require("bufferline.commands").cycle(vim.v.count1)
              end
            '';
          options.desc = "Next buffer";
        }

        {
          key = "<Left>";
          action.__raw =
            # lua
            ''
              function()
                require("bufferline.commands").cycle(-vim.v.count1)
              end
            '';
          options.desc = "Previous buffer";
        }

        {
          key = "]b";
          action.__raw =
            # lua
            ''
              function()
                require("bufferline.commands").move(vim.v.count1)
                end
            '';
          options.desc = "Move buffer tab right";
        }

        {
          key = "[b";
          action.__raw =
            # lua
            ''
              function()
                require("bufferline.commands").move(-vim.v.count1)
                end
            '';
          options.desc = "Move buffer tab left";
        }

        {
          key = "<leader>j";
          action.__raw =
            # lua
            ''function() require("bufferline.commands").pick() end'';
          options.desc = "Jump to buffer";
        }

        {
          key = "<leader>bc";
          action.__raw =
            # lua
            ''
              function()
                require("bufferline.commands").close_others()
              end
            '';
          options.desc = "Close all other buffers";
        }

        {
          key = "<leader>bx";
          action.__raw =
            # lua
            ''
              function()
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                  if vim.bo[buf].buflisted and vim.fn.win_findbuf(buf)[1] == nil then
                    vim.api.nvim_buf_delete(buf, { force = false })
                  end
                end
              end
            '';
          options.desc = "Close buffers not in any window";
        }

        {
          key = "<leader>br";
          action.__raw =
            # lua
            ''
              function()
                require("bufferline.commands").close_in_direction "right"
              end
            '';
          options.desc = "Close buffers to the right";
        }

        {
          key = "<leader>bl";
          action.__raw =
            # lua
            ''
              function()
                require("bufferline.commands").close_in_direction "left"
              end
            '';
          options.desc = "Close buffers to the left";
        }

        {
          key = "<leader>bp";
          action = "<cmd>BufferLineTogglePin<cr>";
          options = {
            desc = "Toggle pin";
            silent = true;
          };
        }

        {
          key = "<leader>bP";
          action = "<Cmd>BufferLineGroupClose ungrouped<CR>";
          options = {
            desc = "Close non-pinned buffers";
            silent = true;
          };
        }

        {
          key = "<leader>ub";
          action.__raw =
            # lua
            ''
              function()
                vim.g.buffer_limit_enabled = not vim.g.buffer_limit_enabled
                local status = vim.g.buffer_limit_enabled and "STRICT" or "OFF"
                local level = vim.g.buffer_limit_enabled and vim.log.levels.INFO or vim.log.levels.WARN

                vim.notify("Buffer limit: " .. status, level, {
                  title = "Buffer Manager",
                  icon = "󰓩 ";
                })
              end
            '';
          options.desc = "Toggle open buffer limit";
        }
      ]
      |> map (m: m // { mode = "n"; })
      |> lib.optionals cfg.enable;
  };
}
