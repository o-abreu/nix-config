{
  pkgs,
  lib,
  ...
}:
{
  home.packages = [ pkgs.celluloid ];
  xdg.mimeApps.defaultApplications = lib.genAttrs [
    "video/x-matroska"
    "video/mp4"
  ] (_: "celluloid.desktop");
}
