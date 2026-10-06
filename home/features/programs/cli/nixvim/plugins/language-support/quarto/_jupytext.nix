{
  languages,
  lib,
}: {
  programs.nixvim.plugins.jupytext = {
    enable = true;
    settings.custom_language_formatting = lib.genAttrs languages (_: {
      extension = "qmd";
      style = "quarto";
      force_ft = "quarto";
    });
  };
}
