{
  lib,
  config,
  ...
}: {
  # INFO: Zathura status bar legibility overrides on top of stylix's zathura
  # target.
  programs.zathura.options = {
    font = with config.stylix.fonts;
      lib.mkDefault "${monospace.name} ${toString sizes.terminal}";
    statusbar-fg = lib.mkForce config.lib.stylix.colors.withHashtag.base05;
    statusbar-v-padding = 5;
  };
}
