# INFO: Patch snacks.nvim to guard against stale parent window ids
# during nvim_open_win (see pkgs/snacks-nvim-fix/default.nix header).
final: prev: {
  vimPlugins = prev.vimPlugins // {
    snacks-nvim = final.callPackage ../pkgs/snacks-nvim-fix {
      inherit (prev.vimPlugins) snacks-nvim;
    };
  };
}
