{
  config,
  lib,
  ...
}: let
  inherit (config.programs.nixvim.plugins) opencode;
  prefix = "<leader>a";
  cmd = lib.getExe config.programs.opencode.package;
in {
  _module.args.opencode = {
    inherit (opencode) enable;
    inherit prefix cmd;
  };

  programs.nixvim = {
    # INFO: opencode reads files from disk, so unsaved edits in the buffer are
    # invisible to the model. Every opencode keymap below flushes the current
    # buffer first, but with `noautocmd` so BufWritePre/BufWritePost handlers
    # (format-on-save, linters, ...) never fire: they could mutate the buffer
    # or stall the request, and what gets sent is exactly the buffer text.
    globals.save_buffer.__raw =
      lib.mkIf opencode.enable
      ''
        function()
          if vim.bo.modified and vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) ~= "" then
            vim.cmd("silent! noautocmd write")
          end
        end
      '';

    plugins.which-key.settings.spec = lib.mkIf opencode.enable [
      {
        __unkeyed-1 = prefix;
        mode = ["n" "x"];
        group = "AI";
      }
    ];

    keymaps = let
      mkAction = cmd: {__raw = "function() vim.g.save_buffer() require('opencode').${cmd} end";};
      mkExpr = cmd: {__raw = "function() vim.g.save_buffer() return require('opencode').${cmd} end";};
    in
      lib.mkIf opencode.enable [
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
      ];
  };
}
