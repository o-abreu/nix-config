{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [pkgs.vimPlugins.nvim-prose];

    extraConfigLua = ''
      require("nvim-prose").setup({
        wpm = 150, -- Speaking time
        filetypes = { "markdown" },
      })
    '';
    plugins.lualine.settings.sections.lualine_x = let
      display = info: {
        __unkeyed-1.__raw = ''
          function()
            local ok, prose = pcall(require, "nvim-prose")
            return ok and prose.is_available() and prose.${info}() or ""
          end
        '';
      };
    in [
      (display "word_count")
      (display "reading_time")
    ];
  };
}
