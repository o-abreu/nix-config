{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
lib.mkIf config.programs.qalculate.enable {
  programs.nixvim.extraPlugins = [
    {
      plugin = pkgs.vimUtils.buildVimPlugin {
        pname = "qalc.nvim";
        version = "main";
        src = inputs.qalc-nvim;
      };
    }
  ];
}
