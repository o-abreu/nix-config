{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = [
      pkgs.openssh
      pkgs.sshfs
    ];
    extraPlugins = [ pkgs.vimPlugins.sshfs-nvim ];
    extraConfigLua = ''
      require("sshfs").setup({})
    '';
  };
}
