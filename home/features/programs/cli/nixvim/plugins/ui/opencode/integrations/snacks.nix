{
  lib,
  snacksTerminal,
  opencodeNvim,
  ...
}: let
  action = snacksTerminal.toggleTerm opencodeNvim.opts;
in {
  programs.nixvim = {
    plugins = {
      snacks.settings = {
        input.enable = lib.mkDefault true;
        terminal.enabled = lib.mkDefault true;
      };

      opencode.settings.server.start.__raw = lib.mkIf snacksTerminal.enable ''
        function()
          (${action.__raw})()
        end
      '';
    };

    autoCmd = lib.mkIf (opencodeNvim.enable && snacksTerminal.enable) [
      {
        event = "User";
        # INFO: opencode v2 event shape: `event.data` (v1 used
        # `event.properties`). Upstream suggests showing the terminal when
        # OpenCode starts executing, since prompts are submitted over HTTP
        # whether or not the TUI is open.
        #
        # `terminal.get(cmd, { create = false })` cannot find the TUI: a snacks
        # terminal id hashes `cwd` and the slot, and this terminal is created
        # with `count = 8` and a pinned cwd, while the lookup would use
        # `vim.v.count1` and Neovim's cwd. Match on the command instead,
        # preferring the terminal that belongs to this project tree.
        pattern = "OpencodeEvent:session.execution.started";
        callback.__raw = ''
          function()
            local cwd = vim.fs.normalize(vim.fn.getcwd())
            local fallback
            for _, term in ipairs(require('snacks.terminal').list()) do
              local meta = term.buf and vim.b[term.buf].snacks_terminal
              if meta and meta.cmd == '${opencodeNvim.opts.cmd}' then
                local dir = meta.cwd and vim.fs.normalize(meta.cwd)
                local related = dir
                  and (
                    dir == cwd
                    or dir:sub(1, #cwd + 1) == cwd .. "/"
                    or cwd:sub(1, #dir + 1) == dir .. "/"
                  )
                if related then
                  term:show()
                  return
                end
                fallback = fallback or term
              end
            end
            if fallback then
              fallback:show()
            end
          end
        '';
      }
    ];
  };
}
