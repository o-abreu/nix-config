{config, ...}: {
  programs.nixvim.extraConfigLua = with config.lib.stylix.colors.withHashtag;
  # lua
    ''
      local csvview_palette = {
        [0] = "${base0F}",
        [1] = "${base09}",
        [2] = "${base0A}",
        [3] = "${base0B}",
        [4] = "${base0C}",
        [5] = "${base0D}",
        [6] = "${base0E}",
        [7] = "${base08}",
        [8] = "${base07}",
      }

      local function csvview_apply_palette()
        for i = 0, 8 do
          local color = csvview_palette[i]
          -- `csvColN` drives the built-in csv syntax, `CsvViewColN` drives
          -- csvview's extmarks. Set both so toggling csvview off keeps the
          -- same palette.
          vim.api.nvim_set_hl(0, "csvCol" .. i, { fg = color })
          vim.api.nvim_set_hl(0, "CsvViewCol" .. i, { fg = color })
        end
      end

      csvview_apply_palette()
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = csvview_apply_palette,
        desc = "Apply the csvview column palette",
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "CsvViewAttach",
        callback = csvview_apply_palette,
        desc = "Apply the csvview column palette",
      })
    '';
}
