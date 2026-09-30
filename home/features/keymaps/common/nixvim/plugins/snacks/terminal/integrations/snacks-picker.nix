{ lib, snacksTerminal, ... }:
with snacksTerminal;
let
  # INFO: Drop the terminal prefixes from the picker so the global terminal
  # keymaps keep working while a picker is focused.
  clear = lib.genAttrs [ prefix replPrefix ] (_: false);
  override = {
    input.keys = clear;
    list.keys = clear;
  };
in
{
  programs.nixvim.plugins.snacks.settings.picker = {
    win = lib.mkIf enable override;
    sources.explorer.win = lib.mkIf enable override;
  };
}
