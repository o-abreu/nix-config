{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.nixvim.plugins.snacks;
  enable = cfg.enable && (cfg.settings.terminal.enabled or false);
in
{
  programs.nixvim = {
    # 1. Pull the raw plugin package from nixpkgs
    extraPlugins = [
      pkgs.vimPlugins.flatten-nvim
    ];

    # 2. Setup the plugin early in the Neovim boot process
    extraConfigLuaPre = ''
      local saved_term_win
      local saved_term

        require("flatten").setup({
          window = {
            open = "alternate"
          },
          hooks = {
            pre_open = function()
              -- Grab the Neovim window ID of the Snacks terminal and remember the
              -- metadata Snacks keyed it by (cmd, cwd, env, count) so it can be
              -- toggled back verbatim, regardless of how it was opened.
              saved_term_win = vim.api.nvim_get_current_win()
              saved_term = vim.b.snacks_terminal
            end,

            post_open = function()
              -- Hide the terminal window natively; Snacks handles the cleanup
              if saved_term_win and vim.api.nvim_win_is_valid(saved_term_win) then
                vim.api.nvim_win_hide(saved_term_win)
              end
            end,

          ${lib.optionalString enable ''
            block_end = function()
              -- Toggle the Snacks terminal back open when a blocking command finishes.
              -- Reuse the captured metadata so the tid matches the original terminal
              -- (count included), restoring it instead of spawning a new one.
              if saved_term then
                require("snacks").terminal.toggle(saved_term.cmd, {
                  cwd = saved_term.cwd,
                  env = saved_term.env,
                  count = saved_term.id,
                })
              else
                require("snacks").terminal.toggle()
              end
            end,
          ''}
          }
        })
    '';
  };
}
