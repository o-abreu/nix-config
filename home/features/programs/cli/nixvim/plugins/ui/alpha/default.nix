# INFO: Dashboard screen
{
  config,
  lib,
  pkgs,
  ...
}:
let
  mkDashboardButton = import ./_mkDashboardButton.nix { inherit config lib; };

  # INFO: Dashboard button entries are contributed by the keymap modules
  # through `plugins.alpha.dashboardButtons`. Entries with an explicit
  # `key`+`action` are rendered verbatim; the rest resolve their key/action
  # from `config.programs.nixvim.keymaps` by `desc`.
  renderButton =
    e:
    if e.key != null && e.action != null then
      ''dashboard.button("${e.key}", "${e.icon}  ${e.desc}", "${e.action}"),''
    else
      mkDashboardButton e.desc e.icon;

  # INFO: The merged list is already ordered by the module system (mkOrder).
  # The two-column layout splits it in half (first half = left column).
  entries = config.programs.nixvim.plugins.alpha.dashboardButtons;
  dashboardButtons = map renderButton entries;
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

    # INFO: Not backed by a keymap (it cycles the alpha-ascii header), so it is
    # declared here with an explicit key/action and pinned second-to-last.
    plugins.alpha.dashboardButtons = lib.mkOrder 1900 [
      {
        desc = "Change header image";
        icon = "";
        key = "SPC c i";
        action = ":AlphaAsciiNext<CR>";
      }
    ];

    extraConfigLuaPre = "vim.g.start_time = vim.uv.hrtime()";
    extraConfigLua =
      # lua
      ''
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
        local cells = {
            ${builtins.concatStringsSep "\n    " dashboardButtons}
        }
        local two_col = require("alpha.layout.two-col")
        local two_columns = two_col.columns(cells, { gap = 6, width = 34 })

        -- INFO: With no cursor-jumps registered (all buttons live in the custom
        -- element), the default `<CR>` press handler would index an empty jump
        -- table and error. Neutralize it.
        alpha.press = (function(orig)
          return function(...)
            pcall(orig, ...)
          end
        end)(alpha.press)

        dashboard.config.layout = {
            { type = "padding", val = 2 },
            dashboard.section.header,
            { type = "padding", val = 2 },
            two_columns,
            dashboard.section.footer,
        }

        -- INFO: Set up alpha-ascii AFTER the layout so its `setup()` can inject
        -- the randomized ascii header into `dashboard.config.layout[2]` (the
        -- header slot, see `core.lua:set_header_by_index`/`get_header`).
        -- `AlphaAsciiNext` keeps patching layout[2], so both the initial header
        -- and SPC c i work.
        require("alpha_ascii").setup({ header = "random" })
        alpha.setup(dashboard.config)
      '';

    files."lua/alpha/layout/two-col.lua".extraConfigLua = builtins.readFile ./layout/two-col.lua;

    files."lua/alpha/cursor-hidden.lua".extraConfigLua = builtins.readFile ./cursor-hidden/init.lua;

    autoGroups = {
      alpha_cursor.clear = true;
      alpha_startup.clear = true;
    };

    autoCmd =
      let
        hideCursor = {
          __raw =
            # lua
            ''
              function(args)
                vim.schedule(function()
                  if vim.api.nvim_get_current_buf() == args.buf then
                    require("alpha.cursor-hidden").hide()
                  end
                end)
              end
            '';
        };
        restoreCursor = {
          __raw =
            # lua
            ''
              function(args)
                -- Only restore when the buffer we are leaving is the dashboard
                -- (guicursor is global, so it must be restored explicitly).
                local ft = vim.api.nvim_buf_get_option(args.buf, "filetype")
                if ft == "alpha" then
                  vim.schedule(function()
                    require("alpha.cursor-hidden").restore()
                  end)
                end
              end
            '';
        };
      in
      [
        {
          event = "FileType";
          pattern = "alpha";
          group = "alpha_cursor";
          desc = "Hide the text cursor on the Alpha dashboard";
          callback = hideCursor;
        }
        {
          event = [
            "BufLeave"
            "BufWipeout"
          ];
          pattern = "";
          group = "alpha_cursor";
          desc = "Restore the text cursor once the Alpha dashboard is left";
          callback = restoreCursor;
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
