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
    ./_vim-slime.nix
  ];

  programs.nixvim = {
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
    };
  };
}
