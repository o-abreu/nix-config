{ snacksTerminal, lib, ... }:
{
  # INFO: The "Floating terminal" button resolves its key from the keymap with
  # the same `desc` (see `allLayouts` in ../../_layouts.nix).
  programs.nixvim.plugins.alpha.dashboardButtons = lib.optional snacksTerminal.enable {
    desc = "Floating terminal";
    icon = "";
  };
}
