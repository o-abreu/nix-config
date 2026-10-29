{lib, opencode, snacksTerminal, ...}: {
  # INFO: The button resolves its key/action from the keymaps with the same
  # `desc` (see `../terminal.nix`); both opencode bindings share that desc, so
  # the dashboard shows the first one (<leader>at). Gated like the keymaps:
  # without the nixvim plugin or snacks terminals there is nothing to toggle.
  programs.nixvim.plugins.alpha.dashboardButtons =
    lib.optional (opencode.enable && snacksTerminal.enable) {
      desc = "Toggle Opencode buffer";
      icon = "󰚩";
    };
}
