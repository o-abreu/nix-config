{config, ...}: {
  programs.nixvim = {
    plugins = {
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

    autoGroups.presenterm-no-autoformat = {};
    autoCmd = [
      {
        event = ["FileType"];
        pattern = ["markdown"];
        group = "presenterm-no-autoformat";
        desc = "Disable conform format-on-save in presenterm presentation buffers";
        callback.__raw = ''
          function(args)
            vim.schedule(function()
              if vim.api.nvim_get_current_buf() ~= args.buf then
                return
              end
              if require("presenterm.slides").is_presentation() then
                vim.b[args.buf].autoformat = false
              end
            end)
          end
        '';
      }
    ];
  };
}
