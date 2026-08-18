# INFO: Minimal image viewer
{ lib, ... }:
let
  mimeTypes =
    [
      "bmp"
      "gif"
      "jpeg"
      "png"
      "svg+xml"
      "tiff"
      "webp"
      "x-portable-bitmap"
      "x-portable-graymap"
      "x-portable-pixmap"
      "x-xbitmap"
      "x-xpixmap"
    ]
    |> map (el: "image/" + el);

in
{
  programs.feh.enable = true;

  xdg = {
    desktopEntries.feh = {
      name = "feh";
      genericName = "Image Viewer";
      exec = "feh %U";
      terminal = false;
      categories = [
        "Graphics"
        "Viewer"
      ];
      mimeType = mimeTypes;
      icon = "feh";
    };

    mimeApps.defaultApplications = lib.genAttrs mimeTypes (_: "feh.desktop");
  };
}
