{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.blink-cmp-words ];
    extraPackages = [ pkgs.wordnet ];

    plugins.blink-cmp = {
      extraSources = {
        prose = [ "dictionary" ];
        comment = [ "dictionary" ];
        gitcommit = [ "dictionary" ];
      };

      settings.sources.providers.dictionary = {
        name = "Dict";
        module = "blink-cmp-words.dictionary";
        min_keyword_length = 3;
        max_items = 8;
        # INFO: `opts.score_offset` overrides the source's own default of 100
        # (blink-cmp-words/source.lua). The source emits `score_offset - i * 10`
        # per item, so 0 puts the best hit at -10 -- level with `spell` -- and
        # every deeper rank below it. The provider-level `score_offset` is left
        # unset: blink *adds* it to the source's value (provider/list.lua:81),
        # so it must be 0 for this to hold.
        opts = {
          score_offset = 0;
          dictionary_search_threshold = 3;
          definition_pointers = [
            "!"
            "&"
            "^"
          ];
        };
      };
    };
  };
}
