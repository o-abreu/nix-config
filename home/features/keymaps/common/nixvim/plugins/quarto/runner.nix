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

          # INFO: Registered per-buffer so the "Run" group only shows up in
          # quarto buffers. which-key drops spec entries whose `buffer` does not
          # match the current buffer.
          extraConfigLua = ''
            require("which-key").add({
              {
                "${prefix}",
                group = "Run",
                icon = "⚡",
                mode = { "n", "v" },
                buffer = vim.api.nvim_get_current_buf(),
              },
            })
          '';
        };
      };
  };
}
