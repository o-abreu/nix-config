{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [pkgs.vimPlugins.cmp-vimtex];

    plugins = {
      vimtex.enable = true;
      lsp.servers.texlab.enable = true;
      blink-cmp-latex.enable = true;

      blink-cmp = {
        extraSources.default = [
          "latex"
          "vimtex"
        ];

        settings.sources.providers = let
          common = {
            score_offset = 70;
            enabled.__raw =
              # lua
              ''
                function()
                  return vim.bo.filetype == 'tex' or vim.bo.filetype == 'latex'
                end
              '';
          };
        in {
          latex =
            {
              name = "LaTeX";
              module = "blink-cmp-latex";
            }
            // common;

          vimtex =
            {
              name = "VimTeX";
              # INFO: cmp-vimtex is an nvim-cmp source (its entry module exports
              # `setup`, not `new`), so blink must reach it through the compat
              # shim. The registry key is "vimtex" — what the plugin registers
              # under — while `name` stays the human-facing menu label.
              module = "blink.compat.source";
              opts.cmp_name = "vimtex";
            }
            // common;
        };
      };
    };
    # Enable Vimtex concealment and replacement of latex math and control characters.
    globals.conceallevel = 2;
  };
}
