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
      # Gated by the `prose` filetype set in `blink/sources.nix`.
      extraSources.prose = [ "pandoc_references" ];

      settings.sources.providers.pandoc_references =
        lib.mkIf config.programs.nixvim.plugins.cmp-pandoc-references.enable {
          name = "References";
          module = "cmp-pandoc-references.blink";
          score_offset = 2;
        };
    };
  };
}
