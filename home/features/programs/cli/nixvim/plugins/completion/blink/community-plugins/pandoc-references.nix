{
  config,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    cmp-pandoc-references.enable = true;

    blink-cmp = {
      # INFO: `@`-keyed citekey completion from the in-document `bibliography:`
      # file, plus Quarto cross-reference labels. This is a native blink source
      # (`cmp-pandoc-references.blink`), so no blink.compat shim is needed.
      extraSources.default = [ "pandoc_references" ];

      settings.sources.providers.pandoc_references =
        lib.mkIf config.programs.nixvim.plugins.cmp-pandoc-references.enable {
          name = "References";
          module = "cmp-pandoc-references.blink";
          score_offset = 2;
          enabled.__raw =
            # lua
            ''
              function()
                return vim.tbl_contains({ 'markdown', 'quarto', 'rmd', 'pandoc', 'typst' }, vim.bo.filetype)
              end
            '';
        };
    };
  };
}
