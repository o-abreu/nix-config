{ config, lib, ... }:
let
  cfg = config.programs.nixvim.plugins.markdown-preview;
in
{
  programs.nixvim.files."ftplugin/markdown.lua".keymaps = lib.mkIf cfg.enable [
    {
      key = "<localleader>p";
      action = "<cmd>MarkdownPreviewToggle<cr>";
      mode = "n";
      options = {
        buffer = true;
        silent = true;
        desc = "Toggle markdown preview";
      };
    }
  ];
}
