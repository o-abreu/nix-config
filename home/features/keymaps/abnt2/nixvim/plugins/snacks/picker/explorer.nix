{ lib, options, ... }:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim.plugins.snacks.settings.picker.sources.explorer.win.list.keys = {
      j = "explorer_close";
      l = "list_up";
      "<Esc>" = false;
    };
  };
}
