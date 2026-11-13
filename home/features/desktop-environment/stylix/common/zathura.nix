{
  lib,
  config,
  ...
}: {
  # INFO: Zathura status bar legibility overrides on top of stylix's zathura
  # target.
  programs.zathura.options = with config.stylix.fonts; {
    font = lib.mkDefault "${monospace.name} ${toString sizes.terminal}";
    statusbar-fg = lib.mkForce config.lib.stylix.colors.withHashtag.base05;
  };
}
