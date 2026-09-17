{
  programs.nixvim.plugins.render-markdown = {
    lazyLoad.settings.ft = [ "quarto" ];
    settings.file_types = [ "quarto" ];
  };
}
