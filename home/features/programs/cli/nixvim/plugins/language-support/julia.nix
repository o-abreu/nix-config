{ config, lib, ... }: {
  programs.nixvim = {
    lsp.servers.julials.enable = true;
    files = lib.mkIf config.programs.nixvim.plugins.vim-slime.enable {
      "ftplugin/julia.lua".extraConfigLua = ''
        vim.b.slime_cell_delimeter = "^\\s*##"
      '';
    };
  };
}
