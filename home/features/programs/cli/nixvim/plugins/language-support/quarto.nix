{ lib, pkgs, ... }:
let
  handledLanguages = [
    "julia"
    "python"
    "r"
  ];
in
{
  programs.nixvim = {
    extraPackages = [ pkgs.quarto ];
    plugins = {
      quarto = {
        enable = true;
        lazyLoad.settings.ft = [
          "quarto"
          "qmd"
        ];
        settings.lspFeatures.languages = handledLanguages;
      };
      jupytext = {
        enable = true;
        settings.custom_language_formatting = lib.genAttrs handledLanguages (_: {
          extension = "qmd";
          style = "quarto";
          force_ft = "quarto";
        });
      };
      render-markdown = {
        lazyLoad.settings.ft = [ "quarto" ];
        settings.file_types = [ "quarto" ];
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
