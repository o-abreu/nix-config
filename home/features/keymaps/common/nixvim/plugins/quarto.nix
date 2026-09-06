{
  config,
  lib,
  options,
  ...
}:
{
  config = lib.mkIf (options ? programs.nixvim) {
    programs.nixvim =
      let
        enabled = with config.programs.nixvim.plugins; quarto.enable && otter.enable;
        prefix = "<localleader>q";
      in
      {
        plugins.which-key.settings.spec = [
          {
            __unkeyed-1 = prefix;
            mode = "n";
            group = "Quarto";
          }
        ];

        files."ftplugin/quarto.lua" = lib.mkIf enabled {
          keymaps = [
            {
              key = prefix + "p";
              action.__raw = "function() require('quarto').quartoPreview() end";
              options = {
                buffer = true;
                desc = "Preview";
              };
            }

            {
              key = prefix + "c";
              action.__raw = "function() require('quarto').quartoClosePreview() end";
              options = {
                buffer = true;
                desc = "Close preview";
              };
            }

            {
              key = prefix + "h";
              action = ":QuartoHelp";
              options = {
                buffer = true;
                desc = "Help";
              };
            }

            {
              key = prefix + "e";
              action.__raw = "function() require('otter').export() end";
              options = {
                buffer = true;
                desc = "Export";
              };
            }

            {
              key = prefix + "E";
              action.__raw = "function() require('otter').export(true) end";
              options = {
                buffer = true;
                desc = "Export overwrite";
              };
            }
          ];
        };
      };
  };
}
