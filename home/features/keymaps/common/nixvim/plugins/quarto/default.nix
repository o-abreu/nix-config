{
  config,
  lib,
  ...
}: let
  inherit (config.programs.nixvim.plugins) quarto;
  prefix = "<localleader>";
  bind = attr:
    lib.recursiveUpdate {
      mode = "n";
      options.buffer = true;
    }
    attr;
in {
  _module.args.quarto = {
    inherit (quarto) enable;
    inherit prefix bind;
  };

  programs.nixvim.files."ftplugin/quarto.lua".keymaps = let
    inherit (config.programs.nixvim.plugins) quarto;
  in
    lib.optionals quarto.enable [
      (bind {
        key = prefix + "p";
        # INFO: goes through `quarto-preview` so the preview opens in chromium
        # even when a project shadows `quarto` on PATH (see
        # language-support/quarto/_preview-browser.nix).
        action.__raw = "function() require('quarto-preview').preview() end";
        options.desc = "Preview";
      })

      (bind {
        key = prefix + "P";
        action.__raw = "function() require('quarto').quartoClosePreview() end";
        options.desc = "Close preview";
      })

      (bind {
        key = prefix + "H";
        action = ":QuartoHelp";
        options = {
          silent = true;
          desc = "Help";
        };
      })
    ];
}
