{ config, lib, ... }: {
  programs.nixvim = {
    lsp.servers.r_language_server.enable = true;
    files = lib.mkIf config.programs.nixvim.plugins.vim-slime.enable {
      "ftplugin/r.lua".extraConfigLua = ''
        vim.b.slime_cell_delimeter = "#\\s\\=%%"
      '';
    };
  };
}
