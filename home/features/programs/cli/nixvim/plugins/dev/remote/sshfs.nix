{ inputs, pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = [
      pkgs.openssh
      pkgs.sshfs
    ];
    extraPlugins = [
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          pname = "sshfs.nvim";
          version = "main";
          src = inputs.sshfs-nvim;
        };
      }
    ];
    extraConfigLua = ''
      require("sshfs").setup({})
    '';
  };
}
