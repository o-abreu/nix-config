{
  config,
  lib,
  options,
  ...
}:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim = {
      keymaps = lib.mkIf config.programs.nixvim.plugins.snacks.enable [
        {
          mode = "n";
          key = "<leader>e";
          action.__raw = "function() Snacks.explorer() end";
          options.desc = "Toggle Explorer";
        }
        {
          mode = "n";
          key = "<leader>o";
          action.__raw =
            # lua
            ''
              function()
                ${builtins.readFile ./init.lua}
              end
            '';
          options.desc = "Toggle Explorer Focus";
        }
      ];
      plugins.snacks.settings.picker = {
        actions.explorer_focus_code.__raw =
          # lua
          ''
            function(picker)
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                local ft = vim.bo[buf].filetype
                local config = vim.api.nvim_win_get_config(win)
                if config.relative == "" and ft ~= "snacks_picker_list" and ft ~= "snacks_picker_input" then
                  vim.api.nvim_set_current_win(win)
                  break
                end
              end
            end
          '';

        sources.explorer.win = {
          input.keys = {
            "<C-y>" = {
              __unkeyed-1 = "explorer_yank";
              mode = "i";
            };
            "y" = "explorer_yank";

            "<C-o>" = {
              __unkeyed-1 = "explorer_open";
              mode = "i";
            };
            "o" = "explorer_open";

            "<C-e>" = {
              __unkeyed-1 = "explorer_focus_code";
              mode = "i";
            };
          };
          list.keys."<Esc>" = false;
        };
      };
    };
  };
}
