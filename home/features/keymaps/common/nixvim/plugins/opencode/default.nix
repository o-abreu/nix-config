{
  config,
  lib,
  ...
}: let
  inherit (config.programs.nixvim.plugins) opencode;
  prefix = "<leader>a";
  cmd = lib.getExe config.programs.opencode.package;
in {
  _module.args.opencode = {
    inherit (opencode) enable;
    inherit prefix cmd;
  };

  programs.nixvim = {
    plugins.which-key.settings.spec = lib.mkIf opencode.enable [
      {
        __unkeyed-1 = prefix;
        mode = ["n" "x"];
        group = "AI";
      }
    ];

    keymaps = let
      # INFO: OpenCode v2 submits prompts over HTTP to the daemon targeting the
      # most recent session for Neovim's directory, so the old v1 TUI IPC
      # commands (`session.half.page.up/down`, `session.first/last`,
      # `session.interrupt`, `session.new`) are gone: scrolling, navigation and
      # interrupt/new-session are TUI-local now, and the server only executes
      # registered commands (user/plugin-supplied). Session management is done
      # inside the open TUI with its own keybinds.
      mkAction = cmd: {__raw = "function() require('opencode').${cmd} end";};
      mkExpr = cmd: {__raw = "function() return require('opencode').${cmd} end";};
    in
      lib.mkIf opencode.enable [
        {
          key = prefix + "a";
          action = mkAction "ask('@this: ')";
          mode = ["n" "x"];
          options.desc = "Ask";
        }

        {
          key = prefix + "s";
          action = mkAction "select()";
          mode = ["n" "x"];
          options.desc = "Select Prompt";
        }

        {
          key = "go";
          action = mkExpr "operator('@this')";
          mode = ["n" "x"];
          options = {
            desc = "Add range to opencode";
            expr = true;
          };
        }

        {
          key = "goo";
          action = mkExpr "operator('@this ') .. '_'";
          mode = "n";
          options = {
            desc = "Add line to opencode";
            expr = true;
          };
        }

        {
          key = prefix + ".";
          action = mkAction "prompt('@buffer')";
          mode = "n";
          options.desc = "Add buffer to prompt";
        }

        {
          key = prefix + "e";
          action = mkAction "prompt('Explain @this and its context')";
          mode = ["n" "x"];
          options.desc = "Explain this code";
        }
      ];
  };
}
