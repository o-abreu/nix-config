{
  programs.nixvim = {
    # REPL and terminal windows
    plugins.vim-slime.lazyLoad.settings.ft = ["quarto"];

    files."ftplugin/quarto.lua".extraConfigLua = ''
      vim.b.slime_cell_delimiter = "```"
    '';
  };
}
