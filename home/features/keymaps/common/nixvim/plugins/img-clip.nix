{
  config,
  lib,
  options,
  ...
}:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim.files."ftplugin/markdown.lua".keymaps =
      lib.mkIf config.programs.nixvim.plugins.img-clip.enable
        [
          {
            key = "<localleader>P";
            action = "<cmd>PasteImage<cr>";
            mode = "n";
            options = {
              buffer = true;
              silent = true;
              desc = "Paste image from system clipboard";
            };
          }
        ];
  };
}
