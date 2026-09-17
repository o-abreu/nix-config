{
  config,
  lib,
  options,
  ...
}:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim =
      let
        cfg = config.programs.nixvim.plugins;
      in
      {
        plugins.nvim-ufo.settings.preview.mappings = {
          close = "q";
          switch = "K";
        };

        keymaps =
          let
            prefix = "z";
          in
          [
            {
              key = prefix + "R";
              action.__raw = "function() require('ufo').openAllFolds() end";
              options.desc = "Open all folds";
            }
            {
              key = prefix + "M";
              action.__raw = "function() require('ufo').closeAllFolds() end";
              options.desc = "Close all folds";
            }
            {
              key = prefix + "k";
              action.__raw =
                # lua
                ''
                  function()
                    if not require('ufo').peekFoldedLinesUnderCursor() then
                      vim.lsp.buf.hover()
                    end
                  end
                '';
              options.desc = "Peek Folded Lines or Hover";
            }
          ]
          |> map (m: m // { mode = m.mode or "n"; })
          |> lib.mkIf cfg.nvim-ufo.enable;
      };
  };
}
