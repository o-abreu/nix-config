{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.nixvim = {
    # INFO: opencode.nvim (built from `main` for opencode v2 support) shells
    # out to `curl` for all server requests, so it must be on Neovim's PATH.
    # See lua/opencode/server/init.lua in the plugin.
    extraPackages = [pkgs.curl];

    plugins = lib.mkIf config.programs.opencode.enable {
      opencode = {
        # INFO: Upstream `main` — the v2-compatible branch. nixpkgs'
        # `vimPlugins.opencode-nvim` is pinned to v1.0.2, which discovers
        # opencode v1 servers via `pgrep opencode.*--port` + `lsof` and never
        # finds opencode v2 daemons (registered in
        # ~/.local/state/opencode/service.json), making every API keybind
        # spawn a new terminal via `opts.server.start` instead. Promoted from
        # `inputs.opencode-nvim` via overlays/vim-plugins.nix. Revisit once a
        # v2-compatible release tag exists.
        package = pkgs.vimPlugins.opencode-nvim;
        enable = true;
        lazyLoad.settings.lazy = true;
      };
    };

    globals.opencode_opts = {
      events.reload.enabled = true;
    };
  };
}
