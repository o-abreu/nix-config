{config, ...}: {
  programs.nixvim.plugins.lualine.settings.sections.lualine_c = [
    {
      __unkeyed-1 = "%=";
      separator = {
        left = "";
        right = "";
      };
    }

    {
      __unkeyed-1.__raw = ''
        function()
          local reg = vim.fn.reg_recording()
          if reg == "" then return "" end
          return " Recording @" .. reg
        end
      '';

      # Setting a distinctive color to catch the user's eye
      color = {
        fg = config.lib.stylix.colors.withHashtag.base09;
        gui = "bold";
      };
    }
  ];
}
