{
  programs.nixvim.plugins.img-clip.settings.filetypes.quarto = {
    url_encode_path = true;
    template = "![$CURSOR]($FILE_PATH)";
    drag_and_drop.download_images = false;
  };
}
