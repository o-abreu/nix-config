{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib) mkIf optionalAttrs;
in
{
  config = optionalAttrs (options ? programs.nixvim) {
    programs.nixvim =
      let
        enabled = config.programs.nixvim.plugins.quarto.enable or false;
        prefix = "<localleader>r";
      in
      {
        plugins.which-key.settings.spec = mkIf enabled [
          {
            __unkeyed-1 = prefix;
            mode = [
              "n"
              "v"
            ];
            group = "Run";
            icon = "⚡";
          }
        ];

        files."ftplugin/quarto.lua" = mkIf enabled {
          keymaps =
            let
              runner = cmd: { __raw = ''function() require("quarto.runner").${cmd} end''; };
            in
            mkIf enabled [
              {
                key = prefix + "r";
                action = runner "run_cell()";
                mode = "n";
                options = {
                  buffer = true;
                  desc = "current cell";
                };
              }

              {
                key = prefix + "p";
                action = runner "run_above()";
                mode = "n";
                options = {
                  buffer = true;
                  desc = "current cell and previous";
                };
              }

              {
                key = prefix + "a";
                action = runner "run_all()";
                mode = "n";
                options = {
                  buffer = true;
                  desc = "all cells";
                };
              }

              {
                key = prefix + "A";
                action = runner "run_all(true)";
                mode = "n";
                options = {
                  buffer = true;
                  desc = "all cells of all languages";
                };
              }

              {
                key = prefix + "l";
                action = runner "run_line()";
                mode = "n";
                options = {
                  buffer = true;
                  desc = "current line";
                };
              }

              {
                key = prefix;
                mode = "v";
                action = runner "run_range()";
                options = {
                  buffer = true;
                  desc = "Run visual range";
                };
              }
            ];
        };
      };
  };
}
