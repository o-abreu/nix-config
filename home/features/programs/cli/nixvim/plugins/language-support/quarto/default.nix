{
  config,
  lib,
  pkgs,
  ...
}: let
  languages = [
    "julia"
    "python"
    "r"
  ];

  # INFO: Quarto resolves `xdg-open` from PATH (src/core/shell.ts) and ignores
  # $BROWSER, so previews use the system default browser (librewolf via
  # xdg.mimeApps). Shadow only the shell spawned by nvim's `quarto` wrapper
  # with a Chromium-backed `xdg-open`; the rest of the session, including
  # gx/vim.ui.open, keeps the system default.
  xdgOpenChromium = pkgs.writeShellScriptBin "xdg-open" ''
    exec ${lib.getExe config.programs.chromium.finalPackage} "$@"
  '';

  quartoChromium = pkgs.writeShellApplication {
    name = "quarto";
    runtimeInputs = [pkgs.quarto];
    text = ''
      export PATH="${xdgOpenChromium}/bin:$PATH"
      exec quarto "$@"
    '';
  };
in {
  imports = [
    (import ./_jupytext.nix {inherit languages lib;})
    ./_conform.nix
    ./_img-clip.nix
    ./_vim-slime.nix
  ];

  programs.nixvim = {
    # INFO: Only the wrapper: it already carries `pkgs.quarto` as a runtime
    # input, and listing the real CLI too would shadow the wrapper depending on
    # nixvim's PATH-insertion order.
    extraPackages = [quartoChromium];

    plugins = {
      quarto = {
        enable = true;
        lazyLoad.settings.ft = ["quarto"];
        settings = {
          lspFeatures = {inherit languages;};
          codeRunner = {
            enabled = true;
            default_method = "slime";
            never_run = ["yaml"];
          };
        };
      };

      markdown-plus.settings.filetypes = ["quarto"];
      render-markdown = {
        lazyLoad.settings.ft = ["quarto"];
        settings.file_types = ["quarto"];
      };

      snacks = {
        enable = lib.mkDefault true;
        settings.terminal.enable = lib.mkDefault true;
      };

      lint = {
        lintersByFt.quarto = ["markdownlint"];
        linters.markdownlint.cmd = lib.getExe pkgs.markdownlint-cli;
      };
      lsp.servers.marksman.filetypes = ["quarto"];
      luasnip.fromVscode = [{paths = [./snippets];}];
    };
  };
}
