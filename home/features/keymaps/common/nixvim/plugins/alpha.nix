{
  config,
  lib,
  options,
  ...
}:
let
  # Alpha is configured manually via `extraPlugins` + `extraConfigLua` in
  # `plugins/ui/alpha/default.nix`, so `plugins.alpha.enable` is false here.
  alphaEnabled = lib.any (p: (p.pname or "") == "alpha-nvim") config.programs.nixvim.extraPlugins;
in
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim.keymaps = lib.optional alphaEnabled {
      key = "<leader>,";
      action = "<cmd>Alpha<cr>";
      options = {
        buffer = true;
        silent = true;
        desc = "Dashboard";
      };
    };
  };
}
