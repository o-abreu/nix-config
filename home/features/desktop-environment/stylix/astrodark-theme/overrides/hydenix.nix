{
  config,
  lib,
  options,
  ...
}:
{
  config = lib.optionalAttrs (options ? hydenix) {
    hydenix.hm.theme = {
      enable = true;
      active = "One Dark";
      themes = [ "One Dark" ];
    };

    # INFO: Remove items set using HyDE theming
    stylix.targets = {
      qt.enable = false;
      kde.enable = false;
      gtk.enable = false;
      hyprland.enable = false;
      hyprpaper.enable = false;
      hyprlock.enable = false;
      kitty.enable = false;
      rofi.enable = false;
    };
  };
}
