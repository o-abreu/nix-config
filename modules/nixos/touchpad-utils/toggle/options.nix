{ lib, ... }: with lib;
{
  # INFO: Extends programs.hyprland with a touchpad on/off toggle binding helper.
  options.programs.hyprland.touchpadToggle = with types; {
    enable = mkEnableOption "Touchpad on/off toggle";

    name = mkOption {
      type = nullOr str;
      default = null;
      example = "HTIX5288:00 36B6:C001 Touchpad";
      description = ''
        Name of the touchpad input device as shown by `hyprctl devices`,
        or `grep -i touchpad /proc/bus/input/devices`.
      '';
    };

    package = mkOption {
      type = package;
      readOnly = true;
    };
  };
}
