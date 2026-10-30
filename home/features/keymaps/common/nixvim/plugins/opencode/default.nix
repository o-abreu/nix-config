{
  lib,
  opencodeNvim,
  snacksTerminal,
  ...
}: let
  prefix = "<leader>a";
  action = snacksTerminal.toggleTerm opencodeNvim.opts;
in {
  programs.nixvim = {
    # INFO: opencode reads files from disk, so unsaved edits in the buffer are
    # invisible to the model. Every opencode keymap below flushes the current
    # buffer first, but with `noautocmd` so BufWritePre/BufWritePost handlers
    # (format-on-save, linters, ...) never fire: they could mutate the buffer
    # or stall the request, and what gets sent is exactly the buffer text.
    globals.save_buffer.__raw =
      lib.mkIf opencodeNvim.enable
      ''
        function()
          if vim.bo.modified and vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) ~= "" then
            vim.cmd("silent! noautocmd write")
          end
        end
      '';

    plugins.which-key.settings.spec = lib.mkIf opencodeNvim.enable [
      {
        __unkeyed-1 = prefix;
        mode = ["n" "x"];
        group = "AI";
      }
    ];

    keymaps = let
      # INFO: OpenCode v2 submits prompts over HTTP to the daemon targeting the
      # most recent session for Neovim's directory, so the old v1 TUI IPC
      # commands (`session.half.page.up/down`, `session.first/last`,
      # `session.interrupt`, `session.new`) are gone: scrolling, navigation and
      # interrupt/new-session are TUI-local now, and the server only executes
      # registered commands (user/plugin-supplied). Session management is done
      # inside the open TUI with its own keybinds.
      mkAction = cmd: {__raw = "function() vim.g.save_buffer() require('opencode').${cmd} end";};
      mkExpr = cmd: {__raw = "function() vim.g.save_buffer() return require('opencode').${cmd} end";};
    in
      [
        {
          key = prefix + "a";
          action = mkAction "ask('@this: ')";
          mode = ["n" "x"];
          options.desc = "Ask";
        }

        {
          key = prefix + "s";
          action = mkAction "select()";
          mode = ["n" "x"];
          options.desc = "Select Prompt";
        }

        {
          key = "go";
          action = mkExpr "operator('@this')";
          mode = ["n" "x"];
          options = {
            desc = "Add range to opencode";
            expr = true;
          };
        }

        {
          key = "goo";
          action = mkExpr "operator('@this ') .. '_'";
          mode = "n";
          options = {
            desc = "Add line to opencode";
            expr = true;
          };
        }

        {
          key = prefix + ".";
          action = mkAction "prompt('@buffer')";
          mode = "n";
          options.desc = "Add buffer to prompt";
        }

        {
          key = prefix + "e";
          action = mkAction "prompt('Explain @this and its context')";
          mode = ["n" "x"];
          options.desc = "Explain this code";
        }
      ]
      ++ lib.optionals snacksTerminal.enable [
        {
          inherit action;
          key = prefix + "t";
          mode = "n";
          options.desc = "Toggle Opencode buffer";
        }

        {
          inherit action;
          key = "<C-.>";
          mode = ["n" "t"];
          options.desc = "Toggle Opencode buffer";
        }
      ]
      |> lib.mkIf opencodeNvim.enable;
  };
}
