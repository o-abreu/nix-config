{ pkgs, ... }:
{
  programs.nixvim = {
    globals.rainbow_delimiters.blacklist = [
      "markdown"
      "markdown_inline"
    ];

    extraPlugins = [
      {
        plugin = pkgs.vimPlugins.rainbow-delimiters-nvim;
        optional = true;
      }
    ];
  };

  programs.nixvim.plugins.lz-n.plugins = [
    {
      __unkeyed-1 = "rainbow-delimiters.nvim";
      event = [
        "BufReadPre"
        "BufNewFile"
      ];
    }
  ];
}
