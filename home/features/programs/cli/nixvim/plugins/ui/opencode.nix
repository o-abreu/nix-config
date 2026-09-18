{
  config,
  lib,
  pkgs,
  ...
}:
let
  snacks = config.programs.nixvim.plugins.snacks;
  opencode = config.programs.opencode;
  opencodeCmd = lib.getExe opencode.package;

  # INFO: Following the latest release.
in
{
  programs.nixvim = {
    # INFO: lsof is required by opencode.nvim for port discovery when searching
    # for running opencode servers. See lua/opencode/server/process/unix.lua.
    extraPackages = [ pkgs.lsof ];

    plugins = lib.mkIf opencode.enable {
      opencode = {
        package = pkgs.unstable.vimPlugins.opencode-nvim;
        enable = true;
        lazyLoad.settings.lazy = true;

        settings = {
          server =
            let
              snacks_terminal_opts = config.lib.nixvim.lua.toLuaObject {
                win = {
                  position = "right";
                  enter = false;
                };
              };
            in
            lib.mkIf snacks.enable {
              start.__raw = "function() require('snacks.terminal').open('${opencodeCmd}', ${snacks_terminal_opts}) end";
            };
        };
      };

      # INFO: Statusline segment showing the opencode session state.
      #
      # The path is `settings.sections.lualine_z` (not `settings.lualine_z.
      # sections`); the latter was silently absorbed as a NEW top-level key by
      # the `freeformType` on `settings`, so the component never rendered.
      #
      # `sections.<name>` is a list of components, and lualine assigns it
      # wholesale (`config.lua:129`), replacing its own default rather than
      # merging. `lualine_z` defaults to `{ "location" }`, so restate it here to
      # keep the cursor position in the statusline.
      lualine.settings.sections.lualine_z = [
        "location"
        {
          __unkeyed-1.__raw = "function() local ok, s = pcall(require, 'opencode') return ok and s.statusline() or '' end";
        }
      ];
    };

    globals.opencode_opts = {
      lsp.enabled = true;
      events.reload.enabled = true;
    };

    autoCmd = lib.mkIf snacks.enable [
      {
        event = "User";
        pattern = "OpencodeEvent:tui.command.execute";
        callback.__raw = ''
          function(args)
            local event = args.data.event
            if event.properties.command == 'prompt.submit' then
              local win = require('snacks.terminal').get('${opencodeCmd}', { create = false })
              if win then
                win:show()
              end
            end
          end
        '';
      }
    ];
  };
}
