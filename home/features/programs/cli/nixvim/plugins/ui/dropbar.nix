{
  programs.nixvim = {
    plugins.dropbar = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
    };
  };
}
