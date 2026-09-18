{
  config,
  lib,
  options,
  ...
}:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim.files =
      let
        cfg = config.programs.nixvim.plugins.img-clip;
        filetypes = [
          "markdown"
          "latex"
          "typst"
          "quarto"
        ];
        keybind = {
          key = "<localleader>P";
          action = "<cmd>PasteImage<cr>";
          mode = "n";
          options = {
            buffer = true;
            silent = true;
            desc = "Paste image from system clipboard";
          };
        };
      in
      map (elem: "ftplugin/${elem}.lua") filetypes
      |> lib.flip lib.genAttrs (_: {
        keymaps = lib.optional cfg.enable keybind;
      });
  };
}
