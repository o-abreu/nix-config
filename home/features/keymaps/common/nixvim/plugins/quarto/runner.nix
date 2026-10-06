{
  config,
  lib,
  quarto,
  ...
}: {
  programs.nixvim.files."ftplugin/quarto.lua" = let
    inherit (quarto) bind;
    prefix = quarto.prefix + "r";
  in
    lib.mkIf quarto.enable {
      keymaps = let
        runner = cmd: {__raw = ''function() require("quarto.runner").${cmd} end'';};
      in [
        (bind {
          key = prefix + "r";
          action = runner "run_cell()";
          options.desc = "current cell";
        })

        (bind {
          key = prefix + "p";
          action = runner "run_above()";
          options.desc = "current cell and previous";
        })

        (bind {
          key = prefix + "a";
          action = runner "run_all()";
          options.desc = "all cells";
        })

        (bind {
          key = prefix + "A";
          action = runner "run_all(true)";
          options.desc = "all cells of all languages";
        })

        (bind {
          key = prefix + "l";
          action = runner "run_line()";
          options.desc = "current line";
        })

        (bind {
          key = prefix;
          mode = "v";
          action = runner "run_range()";
          options.desc = "Run visual range";
        })
      ];

      extraConfigLua = lib.mkIf config.programs.nixvim.plugins.which-key.enable ''
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
}
