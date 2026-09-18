{
  config,
  ...
}:
{
  programs.nixvim.plugins = {
    presenterm-nvim = {
      inherit (config.programs.presenterm) enable;
    };

    # INFO: `sections.lualine_x` must be a LIST of components; lualine iterates
    # each section with `pairs()`. Nixvim types this option as
    # `maybeRaw (listOf ...)`, so assigning a bare `__raw` function type-checks
    # but produces `lualine_x = function()` at runtime, which blows up with
    # "bad argument #1 to 'pairs' (table expected, got function)". Hence the
    # function goes *inside* the list.
    #
    # The `pcall` guards the statusline: if `programs.presenterm.enable` is
    # false the plugin is not installed, so `require("presenterm")` would throw
    # on every redraw. Matches the pattern in plugins/ui/opencode.nix.
    lualine.settings.sections.lualine_x = [
      {
        __unkeyed-1.__raw = ''
          function()
            local ok, presenterm = pcall(require, "presenterm")
            return ok and presenterm.slide_status() or ""
          end
        '';
      }
    ];
  };
}
