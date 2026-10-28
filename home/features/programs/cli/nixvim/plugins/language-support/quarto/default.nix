{
  lib,
  pkgs,
  ...
}: let
  languages = [
    "julia"
    "python"
    "r"
  ];
in {
  imports = [
    (import ./_jupytext.nix {inherit languages lib;})
    ./_conform.nix
    ./_img-clip.nix
    ./_preview-browser.nix
    ./_vim-slime.nix
  ];

  programs.nixvim = {
    # INFO: The real CLI only. The preview browser is picked by the
    # `quarto-preview` helper (see _preview-browser.nix), which prepends a
    # chromium-backed `xdg-open` around the preview spawn. Wrapping this binary
    # instead made the choice depend on PATH order, so a project-provided
    # quarto (devenv, direnv, an exrc) silently reverted previews to the system
    # default browser.
    extraPackages = [pkgs.quarto];

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
