{
  config,
  lib,
  ...
}:
let
  cfg = config.programs.nixvim.plugins.lsp;
  prefix = "<leader>l";
in
{
  programs.nixvim = {
    keymapsOnEvents.LspAttach = lib.mkIf cfg.enable [
      {
        key = prefix + "H";
        mode = "n";
        action.__raw = "vim.diagnostic.open_float";
        options = {
          silent = true;
          desc = "Lsp diagnostic open_float";
        };
      }

      {
        key = prefix + "a";
        mode = "n";
        action.__raw = "vim.lsp.buf.code_action";
        options = {
          silent = true;
          desc = "Lsp buf code_action";
        };
      }

      {
        mode = "n";
        key = prefix + "Q";
        action = "<cmd>checkhealth vim.lsp<cr>";
        options.desc = "Lsp Health";
      }

      {
        mode = "n";
        key = "gR";
        action.__raw = "vim.lsp.buf.rename";
        options = {
          buffer = true;
          silent = true;
          desc = "Lsp buf rename";
        };
      }

      {
        key = "<C-s>";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("noice").cmd.signature()
            end
          '';
        options = {
          silent = true;
          desc = "Noice signature help";
        };
      }
    ];

    lsp.servers.clangd.config.onAttach.function =
      # lua
      ''
        vim.keymap.set(
          'n',
          'gh',
          "<cmd>ClangdSwitchSourceHeader<cr>",
          {
            desc = "Switch Source/Header (C/C++)",
            buffer = bufnr
          }
        )
      '';

    plugins.which-key.settings.spec = lib.optional cfg.enable [
      {
        __unkeyed-1 = prefix;
        group = "LSP";
        icon = " ";
        mode = [
          "n"
          "v"
        ];
      }
    ];
  };
}
