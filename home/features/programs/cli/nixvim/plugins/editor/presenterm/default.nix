{config, ...}: {
  programs.nixvim.plugins = {
    presenterm = {inherit (config.programs.presenterm) enable;};
    luasnip.fromVscode = [{paths = [./snippets];}];
    lualine.settings.sections.lualine_x = [
      {
        __unkeyed-1.__raw = ''
          function()
            local ok, presenterm = pcall(require, "presenterm")
            return ok and presenterm.slide_status() or ""
          end
        '';
      }
    ];
  };
}
