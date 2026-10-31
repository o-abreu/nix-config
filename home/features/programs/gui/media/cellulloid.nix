{
  pkgs,
  lib,
  ...
}: {
  home.packages = [pkgs.celluloid];
  xdg.mimeApps.defaultApplications = lib.genAttrs [
    "video/matroska"
    "audio/matroska"
    "video/mp4"
    "video/x-matroska"
  ] (_: "io.github.celluloid_player.Celluloid.desktop");
}
