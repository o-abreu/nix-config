{
  programs.nixvim.plugins = {
    faster = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";

      settings.behaviours.bigfile.extra_patterns = [
        {
          filesize = 1;
          pattern = "*.log";
        }
        {
          filesize = 0.5;
          pattern = "*.{json,xml}";
        }
        {
          filesize = 1.5;
          pattern = "*.md";
        }
      ];
    };
  };
}
