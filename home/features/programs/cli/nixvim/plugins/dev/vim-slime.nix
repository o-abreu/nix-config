{
  pkgs,
  ...
}:
{
  programs.nixvim = {
    extraPlugins = [
      {
        plugin = pkgs.vimPlugins.vim-slime-cells;
        optional = true;
      }
    ];
    globals.slime_cell_delimiter = "^$";

    plugins.vim-slime = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings.cmd =
          builtins.foldl' (acc: s: acc ++ [ "SlimeSend${s}" ])
            [ "SlimeConfig" ]
            [ "CurrentLine" "1" "0" "" ];
      };
      settings = {
        target = "neovim";
        bracketed_paste = 1;
        suggest_default = 1;
      };
    };
  };
}
