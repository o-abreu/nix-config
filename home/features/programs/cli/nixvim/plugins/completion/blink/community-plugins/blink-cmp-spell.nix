{
  config,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    blink-cmp-spell.enable = true;

    blink-cmp = {
      extraSources = {
        default = [ "spell" ];
        gitcommit = [ "spell" ];
      };

      settings.sources.providers.spell =
        lib.mkIf config.programs.nixvim.plugins.blink-cmp-spell.enable {
          name = "Spell";
          module = "blink-cmp-spell";
          min_keyword_length = 5;
          max_items = 3;
          score_offset = -10;
        };
    };
  };
}
