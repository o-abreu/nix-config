{
  config,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    blink-emoji.enable = true;

    blink-cmp = {
      extraSources = {
        prose = [ "emoji" ];
        comment = [ "emoji" ];
        gitcommit = [ "emoji" ];
      };

      settings.sources.providers.emoji =
        lib.mkIf config.programs.nixvim.plugins.blink-emoji.enable {
          name = "Emoji";
          module = "blink-emoji";
          score_offset = 0;
        };
    };
  };
}
