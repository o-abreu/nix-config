{
  lib,
  opencodeNvim,
  snacksTerminal,
  ...
}: {
  programs.nixvim.plugins.alpha.dashboardButtons = lib.optional (opencodeNvim.enable && snacksTerminal.enable) {
    desc = "Toggle Opencode buffer";
    icon = "󰚩";
  };
}
