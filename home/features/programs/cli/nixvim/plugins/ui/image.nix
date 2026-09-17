# TODO: Migrate to kitty terminal for better image rendering compatibility once multiplexing gets handled by herdr.

{ pkgs, ... }: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      imagemagick # Image conversion (required for image module)
      ghostscript # PDF rendering
      mermaid-cli # Mermaid diagrams
      typst # Math expression rendering
      tectonic # LaTeX for math expressions
    ];

    plugins = {
      snacks.settings.image = {
        enabled = true;
        doc = {
          enabled = true;
          float = true;
          max_width = 100;
          max_height = 12;
        };
      };
      molten.settings.image_provider = "snacks.image";
    };

    autoCmd = [
      {
        event = "FileType";
        pattern = [ "quarto" ];
        callback.__raw = ''
          function(e)
            local img = require("snacks.image")
            img.setup()
            img.doc.attach(e.buf)
          end
        '';
      }
    ];
  };
}
