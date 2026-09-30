{ quarto, lib, ... }: {
  programs.nixvim.plugins.jupytext = {
    enable = true;
    settings.custom_language_formatting = lib.genAttrs quarto.languages (_: {
      extension = "qmd";
      style = "quarto";
      force_ft = "quarto";
    });
  };
}
