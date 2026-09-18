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
            ${mkDashboardButton "New/Open file" icons.file.new}
            ${mkDashboardButton "Smart Find Files" icons.search}
            ${mkDashboardButton "Grep Files" icons.file.word}
            ${mkDashboardButton "Recent" icons.refresh}
            ${mkDashboardButton "Toggle Explorer" icons.folder.open}
            dashboard.button("SPC c i", "${icons.customize}  Change header image", ":AlphaAsciiNext<CR>"),
            ${mkDashboardButton "Quit Nixvim" icons.tabClose}
        }

        alpha.setup(dashboard.config)
      '';

    files."lua/alpha/whitelist-keybinds.lua".extraConfigLua =
      builtins.readFile ./whitelist-keybinds/init.lua;

    plugins.which-key.settings.disable.ft = [ "alpha" ];

    autoGroups = {
      alpha_keybind_lock.clear = true;
      alpha_startup.clear = true;
    };

    autoCmd =
      let
        lockDashboard = {
          __raw =
            # lua
            ''
              function(args)
                vim.schedule(function()
                  require("alpha.whitelist-keybinds").lock(args.buf)
                end)
              end
            '';
        };
      in
      [
        {
          event = "FileType";
          pattern = "alpha";
          group = "alpha_keybind_lock";
          desc = "Block all keymaps on the Alpha dashboard except its buttons";
          callback = lockDashboard;
        }
        {
          event = "User";
          pattern = "AlphaRemap";
          group = "alpha_keybind_lock";
          desc = "Re-apply the Alpha dashboard keymap lock";
          callback = lockDashboard;
        }
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
