{
  programs.nixvim = {
    plugins = {
      vimtex = {
        enable = true;
        settings.mappings_prefix = "<localleader>";
      };
      lsp.servers.texlab.enable = true;
      cmp-vimtex.enable = true;
      blink-cmp-latex.enable = true;

      blink-cmp = {
        extraSources.default = [
          "latex"
          "vimtex"
        ];

        settings.sources.providers =
          let
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
          in
          {
            latex = {
              name = "LaTeX";
              module = "blink-cmp-latex";
            }
            // common;

            vimtex = {
              name = "VimTeX";
              module = "cmp-vimtex";
            }
            // common;
          };
      };
    };
    # Enable Vimtex concealment and replacement of latex math and control characters.
    globals.conceallevel = 2;
  };
}
