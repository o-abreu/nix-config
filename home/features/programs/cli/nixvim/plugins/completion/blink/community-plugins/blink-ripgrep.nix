{
  config,
  lib,
  ...
}: {
  programs.nixvim.plugins = {
    blink-ripgrep.enable = true;

    blink-cmp = {
      extraSources.default = [ "ripgrep" ];

      settings.sources.providers.ripgrep =
        lib.mkIf config.programs.nixvim.plugins.blink-ripgrep.enable {
          name = "Ripgrep";
          module = "blink-ripgrep";
          async = true;
          timeout_ms = 500;
          max_items = 10;
          min_keyword_length = 4;
          score_offset = 5;
        };
    };
  };
}
