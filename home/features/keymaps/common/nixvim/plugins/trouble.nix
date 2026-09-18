{
  config,
  lib,
  options,
  ...
}:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {

    programs.nixvim =
      let
        cfg = config.programs.nixvim.plugins.trouble;
        prefix = "<leader>x";
      in
      {
        plugins.which-key.settings.spec = lib.optional cfg.enable {
          __unkeyed-1 = prefix;
          mode = "n";
          icon = "";
          group = "Trouble";
        };

        keymaps =
          [
            {
              key = prefix + "x";
              action = "<cmd>Trouble diagnostics toggle<cr>";
              options.desc = "Diagnostics toggle";
            }
            {
              key = prefix + "X";
              action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
              options.desc = "Buffer Diagnostics toggle";
            }
            {
              key = prefix + "s";
              action = "<cmd>Trouble symbols toggle focus=false<cr>";
              options.desc = "Symbols toggle";
            }
            {
              key = prefix + "l";
              action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
              options.desc = "LSP Definitions / references / ... toggle";
            }
            {
              key = prefix + "L";
              action = "<cmd>Trouble loclist toggle<cr>";
              options.desc = "Location List toggle";
            }
            {
              key = prefix + "Q";
              action = "<cmd>Trouble qflist toggle<cr>";
              options.desc = "Quickfix List toggle";
            }
          ]
          |> map (
            m:
            m
            // {
              mode = m.mode or "n";
              options.silent = true;
            }
          )
          |> lib.mkIf cfg.enable;
      };
  };
}
