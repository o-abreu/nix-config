{
  programs.nixvim = {
    plugins = {
      dap.enable = true;

      blink-cmp.settings.sources.providers.dap = {
        name = "dap";
        module = "blink.compat.source";
        score_offset = 100;
      };
    };
  };
}
