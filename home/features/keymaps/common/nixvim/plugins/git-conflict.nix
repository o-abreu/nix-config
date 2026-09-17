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
        cfg = config.programs.nixvim.plugins.git-conflict;
        prefix = "<leader>gc";
        cmd = c: "<cmd>GitConflict${c}<cr>";
      in
      {
        plugins = {
          git-conflict.settings.default_mappings = false;
          which-key.settings.spec = lib.mkIf cfg.enable [
            {
              __unkeyed-1 = prefix;
              mode = "n";
              group = "Conflict";
            }
          ];
        };
        keymaps =
          [
            {
              key = prefix + "o";
              action = cmd "ChooseOurs";
              options.desc = "Choose our changes";
            }

            {
              key = prefix + "t";
              action = cmd "ChooseTheirs";
              options.desc = "Choose their changes";
            }

            {
              key = prefix + "b";
              action = cmd "ChooseBoth";
              options.desc = "Choose both changes";
            }

            {
              key = prefix + "0";
              action = cmd "ChooseNone";
              options.desc = "Choose none of the changes";
            }

            {
              key = "]x";
              action = cmd "NextConflict";
              options.desc = "Move to next conflict";
            }

            {
              key = "[x";
              action = cmd "PrevConflict";
              options.desc = "Move to previous conflict";
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
