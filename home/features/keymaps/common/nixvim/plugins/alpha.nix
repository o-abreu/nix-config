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
    programs.nixvim.keymapsOnEvents.BufWinEnter = lib.optional alphaEnabled {
      key = "<leader>,";
      action = "<cmd>Alpha<cr>";
      options = {
        buffer = true;
        silent = true;
        desc = "Dashboard";
      };
    };

    programs.nixvim.autoGroups.alpha_no_dashboard_bind.clear = true;
    programs.nixvim.autoCmd = lib.optional alphaEnabled {
      event = "FileType";
      pattern = "alpha";
      group = "alpha_no_dashboard_bind";
      desc = "Hide the Dashboard keybind on the Alpha dashboard";
      callback.__raw = ''
        function(args)
          pcall(vim.keymap.del, "n", "<leader>,", { buffer = args.buf })
        end
      '';
    };
  };
}
