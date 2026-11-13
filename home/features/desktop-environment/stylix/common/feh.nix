{
  config,
  lib,
  pkgs,
  ...
}: let
  fontDir = "${config.xdg.configHome}/feh/fonts";
in {
  # INFO: feh draws all text via Imlib2, which knows nothing about
  # fontconfig: a font spec is a *file* — literally `<name>.ttf` — searched
  # in the font path (feh ships only NotoSans-Medium/yudit), so font family
  # names fail silently at draw time and fall back to NotoSans-Medium. The
  # generic fix: resolve the monospace family *file* with fontconfig's own
  # matching at activation time (`fc-match`), symlink it under a fixed,
  # space-free name (feh's themes parser cannot pass spaces in arguments),
  # and hand that directory to feh via `--fontpath`. The symlink is refreshed
  # on every switch, so it tracks `stylix.fonts.monospace` changes. Size is
  # pixels and does not scale with DPI, so `sizes.terminal` is used.
  xdg.configFile."feh/themes".text = let
    font = "Monospace/${toString config.stylix.fonts.sizes.terminal}";
  in ''
    feh --fontpath ${fontDir} --font ${font} --menu-font ${font}
  '';

  home.activation.stylixFehMonospace =
    lib.hm.dag.entryAfter ["writeBoundary"]
    # bash
    ''
      font_file="$(${pkgs.fontconfig}/bin/fc-match --format '%{file}' '${config.stylix.fonts.monospace.name}:style=Regular')"
      mkdir -p "${fontDir}"
      ln -sfn "$font_file" "${fontDir}/Monospace.ttf"
    '';
}
