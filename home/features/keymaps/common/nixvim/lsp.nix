{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.programs.nixvim.plugins.lsp;
  prefix = "<leader>l";
in
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim = {
      keymapsOnEvents.LspAttach =
        [
          {
            key = prefix + "H";
            action.__raw = "vim.diagnostic.open_float";
            options = {
              desc = "Lsp diagnostic open_float";
            };
          }

          {
            key = prefix + "a";
            action.__raw = "vim.lsp.buf.code_action";
            options = {
              desc = "Lsp buf code_action";
            };
          }

          {
            key = prefix + "Q";
            action = "<cmd>checkhealth vim.lsp<cr>";
            options = {
              desc = "Lsp Health";
            };
          }

          {
            key = "gR";
            action.__raw = "vim.lsp.buf.rename";
            options = {
              buffer = true;
              desc = "Lsp buf rename";
            };
          }
        ]
        |> map (m: m // { mode = m.mode or "n"; })
        |> lib.mkIf cfg.enable;

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
              silent = true;
            }
          )
        '';

      plugins.which-key.settings.spec = lib.optional cfg.enable {
        __unkeyed-1 = prefix;
        group = "LSP";
        icon = " ";
        mode = [
          "n"
          "v"
        ];
      };
    };
  };
}
