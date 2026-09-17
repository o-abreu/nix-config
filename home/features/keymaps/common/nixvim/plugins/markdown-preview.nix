{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.programs.nixvim.plugins.markdown-preview;
in
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim.files = lib.mkIf cfg.enable {
      "ftplugin/markdown.lua" = {
        keymaps = [
          {
            key = "<leader>uM";
            action = "<cmd>MarkdownPreviewToggle<cr>";
            mode = "n";
            options = {
              buffer = true;
              silent = true;
              desc = "Toggle markdown preview";
            };
          }
        ];
      };
    };
  };
}
