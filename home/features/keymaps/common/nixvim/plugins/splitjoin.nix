{ lib, options, ... }:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim.plugins.mini.modules.splitjoin.mappings.toggle = "gS";
  };
}
