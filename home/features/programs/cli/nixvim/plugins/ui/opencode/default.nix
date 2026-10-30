{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.programs.opencode) enable package;
in {
  _module.args.opencodeNvim = {
    inherit enable;
    opts = {
      cmd = lib.getExe package;
      listed = true;
      name = "Opencode";
      # INFO: Always start the TUI at the project root (the repository root when
      # the buffer lives in one), not the initiating buffer's directory: the
      # session, skill and `AGENTS.md` discovery all resolve from the directory
      # opencode runs in, so a file in a subdirectory would otherwise scope them
      # there. Falls back to Neovim's cwd outside a repository.
      cwd = "vim.fs.root(0, '.git') or vim.fn.getcwd()";
      # INFO: Toggled by <leader>at / <C-.> only. Keeping it out of
      # `_G.__last_term` means <C-t> still targets shells/REPLs, so it can be
      # pressed from inside the opencode buffer to float a shell over it.
      remember = false;
      opts = {
        # Distinct snacks slot: lazygit 1, btop 2, float/splits 3, REPLs 4-6.
        count = 8;
        win.position = "current";
      };
    };
  };

  programs.nixvim = {
    # INFO: opencode.nvim (built from `main` for opencode v2 support) shells
    # out to `curl` for all server requests, so it must be on Neovim's PATH.
    # See lua/opencode/server/init.lua in the plugin.
    extraPackages = [pkgs.curl];

    plugins = lib.mkIf config.programs.opencode.enable {
      opencode = {
        inherit enable;
        # INFO: Upstream `main` — the v2-compatible branch. nixpkgs'
        # `vimPlugins.opencode-nvim` is pinned to v1.0.2, which discovers
        # opencode v1 servers via `pgrep opencode.*--port` + `lsof` and never
        # finds opencode v2 daemons (registered in
        # ~/.local/state/opencode/service.json), making every API keybind
        # spawn a new terminal via `opts.server.start` instead. Promoted from
        # `inputs.opencode-nvim` via overlays/vim-plugins.nix. Revisit once a
        # v2-compatible release tag exists.
        package = pkgs.vimPlugins.opencode-nvim;
        lazyLoad.settings.lazy = true;
      };
    };

    globals.opencode_opts.events.reload.enabled = true;
  };
}
