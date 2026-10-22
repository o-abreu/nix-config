{
  config,
  lib,
  ...
}: let
  inherit (config.programs.nixvim.plugins) snacks;
  cmd = lib.getExe config.programs.opencode.package;
in {
  programs.nixvim = {
    plugins = {
      snacks.settings = {
        input.enable = lib.mkDefault true;
        terminal.enable = lib.mkDefault true;
      };

      opencode.settings.server.start.__raw = let
        opts = config.lib.nixvim.lua.toLuaObject {
          win = {
            position = "right";
            enter = false;
          };
        };
      in
        lib.mkIf snacks.enable ''
          function()
            require('snacks.terminal').open('${cmd}', ${opts})
          end
        '';
    };

    autoCmd = lib.mkIf snacks.enable [
      {
        event = "User";
        # INFO: opencode v2 event shape: `event.data` (v1 used
        # `event.properties`). Upstream suggests showing the terminal when
        # OpenCode starts executing, since prompts are submitted over HTTP
        # whether or not the TUI is open.
        pattern = "OpencodeEvent:session.execution.started";
        callback.__raw = ''
          function()
            local win = require('snacks.terminal').get('${cmd}', { create = false })
            if win then
              win:show()
            end
          end
        '';
      }
    ];
  };
}
