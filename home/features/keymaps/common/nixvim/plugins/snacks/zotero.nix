{
  config,
  lib,
  ...
}: {
  programs.nixvim.keymaps = lib.mkIf config.programs.nixvim.plugins.snacks-zotero.enable [
    {
      mode = "n";
      key = "<leader>fz";
      action.__raw =
        # lua
        ''
          function()
            local fts = { 'quarto', 'markdown', 'rmd', 'pandoc', 'typst', 'tex', 'plaintex', 'org', 'asciidoc' }
            if vim.tbl_contains(fts, vim.bo.filetype) then
              vim.cmd('SnacksZotero')
            else
              vim.notify('Zotero picker: unsupported filetype', vim.log.levels.WARN)
            end
          end
        '';
      options.desc = "Zotero citation picker";
    }
  ];
}
