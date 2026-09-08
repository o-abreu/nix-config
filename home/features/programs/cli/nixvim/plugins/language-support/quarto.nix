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
    };
    lsp.servers = {
      julials.enable = true;
      r_language_server.enable = true;
    };
  };
}
