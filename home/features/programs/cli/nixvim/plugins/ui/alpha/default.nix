# INFO: Dashboard screen
{
  config,
  lib,
  pkgs,
  ...
}:
let
  mkDashboardButton = import ./_mkDashboardButton.nix { inherit config lib; };
  icons = import ../_icons.nix;
in
{
  programs.nixvim = {
    # INFO: alpha is configured manually below, so the nixvim `plugins.alpha`
    # module is intentionally disabled. Enabling it always emits its own
    # `require('alpha').setup(...)` (+ `require('alpha.term')`), which would run
    # in addition to the `alpha.setup(dashboard.config)` call below.
    extraPlugins = with pkgs.vimPlugins; [
      alpha-ascii-nvim
      alpha-nvim
    ];
    extraConfigLuaPre = "vim.g.start_time = vim.uv.hrtime()";
    extraConfigLua =
      # lua
      ''
        require("alpha_ascii").setup({ header = "random" })

        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.buttons.val = {
            ${mkDashboardButton "New file" icons.file.new}
            ${mkDashboardButton "Smart Find Files" icons.search}
            ${mkDashboardButton "Grep Files" icons.file.word}
            ${mkDashboardButton "Find marks" icons.bookmarks}
            ${mkDashboardButton "Find Config File" icons.config}
            ${mkDashboardButton "Restore Session" icons.refresh}
            dashboard.button("SPC c i", "  Change header image", ":AlphaAsciiNext<CR>"),
        }

        alpha.setup(dashboard.config)
      '';

    autoGroups.alpha_startup.clear = true;
    autoCmd = [
      {
        event = "User";
        pattern = "AlphaReady";
        group = "alpha_startup";
        desc = "Update Alpha dashboard footer with true startup stats";
        once = true;
        callback.__raw =
          # lua
          ''
            function()
              ${builtins.readFile ./footer/init.lua}
            end
          '';
      }
    ];
  };
}
