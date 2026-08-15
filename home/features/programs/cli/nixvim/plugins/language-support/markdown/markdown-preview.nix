{ pkgs, ... }:
{
  programs.nixvim.plugins.markdown-preview = {
    enable = true;
    package = pkgs.vimPlugins.markdown-preview-nvim;
    autoLoad = true;
  };
}
