{
  pkgs,
  lib,
  ...
}:
let
  # INFO: Celluloid installs its desktop entry under the reverse-DNS id; there is
  # no `celluloid.desktop` in any XDG data dir, so `xdg-mime query default`
  # silently drops that value and `xdg-open` falls back to `$BROWSER`
  # (LibreWolf) for unassociated types.
  desktop = "io.github.celluloid_player.Celluloid.desktop";
in {
  home.packages = [ pkgs.celluloid ];
  xdg.mimeApps.defaultApplications = lib.genAttrs [
    # Canonical names reported by `xdg-mime query filetype` (shared-mime-info
    # >= 2.5). Without these, .mkv/.mka have no handler and open in the browser.
    "video/matroska"
    "audio/matroska"
    "video/mp4"
    # Legacy aliases, kept for older tooling.
    "video/x-matroska"
  ] (_: desktop);
}
