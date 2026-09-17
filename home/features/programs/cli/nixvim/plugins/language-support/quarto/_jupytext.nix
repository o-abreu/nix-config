{ handledLanguages, lib, ... }: {
  programs.nixvim.plugins.jupytext = {
    enable = true;
    settings.custom_language_formatting = lib.genAttrs handledLanguages (_: {
      extension = "qmd";
      style = "quarto";
      force_ft = "quarto";
    });
  };
}
