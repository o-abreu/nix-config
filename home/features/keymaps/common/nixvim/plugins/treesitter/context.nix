{ lib, options, ... }:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim.plugins.treesitter-context.lazyLoad.settings.keys = [
      {
        __unkeyed-1 = "<leader>uT";
        __unkeyed-2 = "<cmd>TSContext toggle<cr>";
        mode = "n";
        silent = true;
        desc = "Treesitter Context toggle";
      }
    ];
  };
}
