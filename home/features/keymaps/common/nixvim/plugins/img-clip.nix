{
  config,
  lib,
  ...
}: {
  programs.nixvim.files =
    [
      "markdown"
      "tex"
      "typst"
      "quarto"
    ]
    |> map (elem: "ftplugin/${elem}.lua")
    |> lib.flip lib.genAttrs (_: {
      keymaps = [
        {
          key = "<localleader>I";
          action = "<cmd>PasteImage<cr>";
          mode = "n";
          options = {
            buffer = true;
            silent = true;
            desc = "Paste image from system clipboard";
          };
        }
      ];
    })
    |> lib.mkIf config.programs.nixvim.plugins.img-clip.enable;
}
