{
  config,
  lib,
  options,
  ...
}:
{
  config = lib.mkIf (options ? programs.nixvim) {
    programs.nixvim.files."ftplugin/markdown.lua" =
      lib.mkIf config.programs.nixvim.plugins.markdown-preview.enable
        {
          keymaps = [
            {
              key = "<leader>uM";
              action = "<cmd>MarkdownPreviewToggle<cr>";
              options = {
                silent = true;
                desc = "Toggle markdown preview";
              };
            }
          ];
        };
  };
}
