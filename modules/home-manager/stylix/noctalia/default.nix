{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.stylix.targets.noctalia;
  theme = "stylix";
in
{
  options.stylix.targets.noctalia = {
    enable = mkEnableOption "noctalia theming" // {
      default = config.programs.noctalia.enable or false;
      defaultText = lib.literalExpression "config.programs.noctalia.enable";
    };
  };

  config = mkIf cfg.enable {
    programs.noctalia = {
      settings.theme = {
        source = "custom";
        custom_palette = theme;
        mode = with config.stylix; if polarity == "dark" then polarity else "light";
      };

      customPalettes.${theme}.dark = with config.lib.stylix.colors.withHashtag; {
        mPrimary = base0D;
        mOnPrimary = base00;
        mSecondary = base0E;
        mOnSecondary = base00;
        mTertiary = base0C;
        mOnTertiary = base00;
        mError = base08;
        mOnError = base00;
        mSurface = base00;
        mOnSurface = base05;
        mHover = base0C;
        mOnHover = base00;
        mSurfaceVariant = base01;
        mOnSurfaceVariant = base04;
        mOutline = base03;
        mShadow = base00;

        terminal = {
          foreground = base05;
          background = base00;
          cursor = base05;
          cursorText = base00;
          selectionFg = base05;
          selectionBg = base02;
          normal = {
            black = base00;
            red = base08;
            green = base0B;
            yellow = base0A;
            blue = base0D;
            magenta = base0E;
            cyan = base0C;
            white = base05;
          };
          bright = {
            black = base03;
            red = base08;
            green = base0B;
            yellow = base0A;
            blue = base0D;
            magenta = base0E;
            cyan = base0C;
            white = base07;
          };
        };
      };

      settings = {
        dock.background_opacity = config.stylix.opacity.desktop;
        notification.background_opacity = config.stylix.opacity.popups;
        osd.background_opacity = config.stylix.opacity.popups;
        shell.font_family = config.stylix.fonts.sansSerif.name;
        wallpaper.default.path = config.stylix.image;
      };
    };
  };
}
