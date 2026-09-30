{
  lib,
  pkgs,
  ...
}:
let
  languages = [
    "julia"
    "python"
    "r"
  ];
in
{
  _module.args.quarto = { inherit languages; };

  imports = [
    ./_jupytext.nix
    ./_img-clip.nix
    ./_vim-slime.nix
  ];

  programs.nixvim = {
    extraPackages = [ pkgs.quarto ];

    plugins = {
      quarto = {
        enable = true;
        lazyLoad.settings.ft = [ "quarto" ];
        settings = {
          lspFeatures = { inherit languages; };
          codeRunner = {
            enabled = true;
            default_method = "slime";
            never_run = [ "yaml" ];
          };
        };
      };

      render-markdown = {
        enable = lib.mkDefault true;
        settings.file_types = [ "quarto" ];
      };

      snacks = {
        enable = lib.mkDefault true;
        settings.terminal.enable = lib.mkDefault true;
      };

      conform-nvim.settings.formatters_by_ft.quarto = [ "deno_fmt" ];
      lint = {
        lintersByFt.quarto = [ "markdownlint" ];
        linters.markdownlint.cmd = lib.getExe pkgs.markdownlint-cli;
      };
      lsp.servers.marksman.filetypes = [ "quarto" ];
    };
  };
}
