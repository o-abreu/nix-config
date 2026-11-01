{
  config,
  lib,
  pkgs,
  ...
}: let
  # INFO: Quarto resolves `xdg-open` from PATH (src/core/shell.ts) and ignores
  # $BROWSER. Wrapping the CLI is not enough: any project that puts its own
  # `quarto` first on PATH (devenv, direnv, an exrc, a venv) bypasses the
  # wrapper and the preview lands in the system default browser. Prepending this
  # shim only around the preview spawn keeps the browser choice independent of
  # PATH order and leaves gx/vim.ui.open on the system default (librewolf via
  # xdg.mimeApps).
  xdgOpenChromium = pkgs.writeShellScriptBin "xdg-open" ''
    exec ${lib.getExe config.programs.chromium.finalPackage} "$@"
  '';
in {
  programs.nixvim.files = {
    "lua/quarto-preview.lua".extraConfigLua =
      # lua
      ''
        local M = {}

        local shim = "${xdgOpenChromium}/bin"

        ---Open the Quarto preview with chromium as the browser.
        ---@param args string|nil extra arguments forwarded to `quarto preview`
        function M.preview(args)
          local path = vim.env.PATH
          -- INFO: `vim.env` writes through to the real environment and `termopen`
          -- spawns synchronously, so the job inherits the shim and PATH can be
          -- restored before control returns.
          vim.env.PATH = shim .. ":" .. path
          local ok, err = pcall(require("quarto").quartoPreview, {args = args})
          vim.env.PATH = path
          if not ok then
            error(err)
          end
        end

        return M
      '';

    # INFO: The plugin creates `:QuartoPreview` (and its variants) in
    # `plugin/quarto.lua`, which lz.n sources before this ftplugin runs, so
    # redefining them with `force` cannot race with the plugin.
    "ftplugin/quarto.lua".extraConfigLua = ''
      if vim.fn.exists(":QuartoPreview") == 2 then
        vim.api.nvim_create_user_command("QuartoPreview", function(opts)
          require("quarto-preview").preview(opts.args)
        end, {nargs = "*", force = true})

        vim.api.nvim_create_user_command("QuartoPreviewNoWatch", function(_)
          require("quarto-preview").preview("--no-watch-inputs")
        end, {nargs = "*", force = true})
      end
    '';
  };
}
