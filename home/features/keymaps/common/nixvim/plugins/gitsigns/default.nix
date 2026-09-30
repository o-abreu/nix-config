{ config, lib, ... }:
{
  programs.nixvim.plugins.gitsigns.settings.on_attach =
    lib.mkIf config.programs.nixvim.plugins.which-key.enable {
      __raw = builtins.readFile ./init.lua;
    };
}
