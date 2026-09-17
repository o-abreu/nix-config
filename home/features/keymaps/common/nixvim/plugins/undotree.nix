{
  config,
  lib,
  options,
  ...
}:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {

    programs.nixvim.keymaps =
      let
        cfg = config.programs.nixvim.plugins.undotree;
      in
      lib.mkIf cfg.enable [
        {
          mode = "n";
          key = "<leader>uU";
          action = "<cmd>UndotreeToggle<CR>";
          options = {
            silent = true;
            desc = "Undotree";
          };
        }
      ];
  };
}
