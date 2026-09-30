{
  programs.nixvim.plugins = {
    lazydev.enable = true;

    blink-cmp = {
      extraSources.default = [ "lazydev" ];
      settings.sources.providers.lazydev = {
        name = "LazyDev";
        module = "lazydev.integrations.blink";
        score_offset = 100;
      };
    };
  };
}
