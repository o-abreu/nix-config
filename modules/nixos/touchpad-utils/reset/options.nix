{
  lib,
  ...
}:
with lib;
{
  # INFO: Re-probes an I2C-HID touchpad. Its HID multitouch collection can come
  #       back dead after an s2idle resume (pointer and/or gestures stop
  #       reporting) even though the device stays bound; unbinding and
  #       rebinding the driver re-runs the probe sequence and revives it.
  options.programs.touchpadReset = with types; {
    enable = mkEnableOption "touchpad reset (I2C-HID driver re-probe)";

    device = mkOption {
      type = nullOr str;
      default = null;
      example = "i2c-HTIX5288:00";
      description = ''
        Name of the I2C-HID device to re-probe, as listed by
        `ls /sys/bus/i2c/drivers/i2c_hid_acpi/`.
      '';
    };

    hidId = mkOption {
      type = nullOr str;
      default = null;
      example = "0018:36B6:C001";
      description = ''
        HID device id, as listed by `ls /sys/bus/hid/devices/`, **without** the
        instance suffix: the kernel appends `.<n>` and bumps it every time the
        device is re-probed, so only the `bus:vendor:product` prefix is stable.
        Used as a fallback when re-probing the I2C device alone does not bring
        the touchpad back.
      '';
    };

    onResume = mkOption {
      type = bool;
      default = true;
      description = "Re-probe the touchpad automatically after resuming from suspend.";
    };

    package = mkOption {
      type = package;
      readOnly = true;
      description = "User-facing command; starts the systemd unit through polkit.";
    };

    rootPackage = mkOption {
      type = package;
      readOnly = true;
      description = "Privileged helper run by `touchpad-reset.service`.";
    };
  };
}
