{ lib, pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.blink-cmp-words ];
    extraPackages = [ pkgs.wordnet ];

    plugins.blink-cmp = {
      extraSources = lib.genAttrs [ "default" "comment" "gitcommit" ] (_: [ "dictionary" ]);

      settings.sources.providers.dictionary = {
        name = "Dict";
        module = "blink-cmp-words.dictionary";
        min_keyword_length = 3;
        max_items = 8;
        score_offset = 8;
        opts = {
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
