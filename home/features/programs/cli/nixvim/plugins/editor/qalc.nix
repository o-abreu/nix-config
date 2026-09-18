{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.programs.qalculate.enable {
  programs.nixvim.extraPlugins = [ pkgs.vimPlugins.qalc-nvim ];
}
