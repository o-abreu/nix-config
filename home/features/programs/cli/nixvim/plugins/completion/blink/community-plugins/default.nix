{pkgs, ...}: {
  programs.nixvim = {
    # INFO: Required by the `git` source below.
    extraPackages = [
      pkgs.gh
      pkgs.glab
    ];

    plugins = {
      # INFO: Required by any `blink.compat.source` provider (dap, vimtex).
      blink-compat.enable = true;
    };
  };
}
