{ lib, ... }: with lib;
{
  # INFO: Extends programs.hyprland with a mirrored/extended display toggle,
  #       so it only ever makes sense in a Hyprland context.
  options.programs.hyprland.mirrorToggle = with types; {
    enable = mkEnableOption "Mirrored/extended display toggle";

    main = mkOption {
      type = nullOr str;
      default = null;
      example = "eDP-1";
      description = ''
        Name of the monitor whose picture gets mirrored onto every other
        connected display. See: `grep -l connected /sys/class/drm/*/status | sed 's|/sys/class/drm/card[0-9]*-||;s|/status||`
      '';
    };

    package = mkOption {
      type = package;
      readOnly = true;
    };
  };
}
