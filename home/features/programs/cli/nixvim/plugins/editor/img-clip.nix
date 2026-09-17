{
  programs.nixvim.plugins.img-clip = {
    enable = true;
    lazyLoad.settings.cmd = [ "PasteImage" ];

    settings = {
      default = {
        dirpath = "imgs";
        drag_and_drop = {
          enabled = true;
          insert_mode = true;
        };
        prompt_for_file_name = false;
        relative_to_current_file = true;
        verbose = false;
      };
    };
  };
}
