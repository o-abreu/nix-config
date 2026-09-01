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
        keymaps = lib.mkIf cfg.enable [
          {
            key = prefix + "o";
            action = cmd "ChooseOurs";
            options = {
              silent = true;
              desc = "Choose our changes";
            };
          }

          {
            key = prefix + "t";
            action = cmd "ChooseTheirs";
            options = {
              silent = true;
              desc = "Choose their changes";
            };
          }

          {
            key = prefix + "b";
            action = cmd "ChooseBoth";
            options = {
              silent = true;
              desc = "Choose both changes";
            };
          }

          {
            key = prefix + "0";
            action = cmd "ChooseNone";
            options = {
              silent = true;
              desc = "Choose none of the changes";
            };
          }

          {
            key = "]x";
            action = cmd "NextConflict";
            options = {
              silent = true;
              desc = "Move to next conflict";
            };
          }

          {
            key = "[x";
            action = cmd "PrevConflict";
            options = {
              silent = true;
              desc = "Move to previous conflict";
            };
          }
        ];
      };
  };
}
