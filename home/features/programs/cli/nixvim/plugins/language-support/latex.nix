{
  pkgs,
  ...
}:
{
  programs.nixvim = {
    # INFO: nixvim has no `cmp-vimtex` module, so the plugin would never land
    # on the runtimepath. Add it explicitly; blink loads it as `cmp_vimtex`
    # (the plugin ships `lua/cmp_vimtex/`, not `lua/cmp-vimtex/`).
    extraPlugins = [ pkgs.vimPlugins.cmp-vimtex ];

    plugins = {
      vimtex = {
        enable = true;
        settings.mappings_prefix = "<localleader>";
      };
      lsp.servers.texlab.enable = true;
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
              module = "cmp_vimtex";
            }
            // common;
          };
      };
    };
    # Enable Vimtex concealment and replacement of latex math and control characters.
    globals.conceallevel = 2;
  };
}
