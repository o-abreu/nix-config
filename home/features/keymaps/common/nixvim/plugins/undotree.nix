{ config, lib, ... }:
{

  programs.nixvim.keymaps = lib.optional config.programs.nixvim.plugins.undotree.enable {
    mode = "n";
    key = "<leader>uU";
    action = "<cmd>UndotreeToggle<CR>";
    options = {
      silent = true;
      desc = "Undotree";
    };
  };
}
