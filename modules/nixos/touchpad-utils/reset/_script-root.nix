{ cfg }:
# bash
''
  DEVICE="${cfg.device}"
  HID_ID="${if cfg.hidId == null then "" else cfg.hidId}"

  I2C_DRIVER=/sys/bus/i2c/drivers/i2c_hid_acpi
  HID_DRIVER=/sys/bus/hid/drivers/hid-multitouch

  # INFO: The device tree needs a moment to settle after resume, so poll for the
  #       binding instead of failing on the first look.
  for _ in {1..20}; do
    if [ -e "$I2C_DRIVER/$DEVICE" ]; then
      break
    fi
    sleep 0.25
  done

  if [ ! -e "$I2C_DRIVER/$DEVICE" ]; then
    echo "touchpad-reset: $DEVICE is not bound to i2c_hid_acpi" >&2
    exit 1
  fi

  # INFO: Re-probing the I2C-HID device replays its reset and power-on sequence,
  #       which re-initialises the whole touchpad. A bound device afterwards
  #       means the driver's probe succeeded.
  reset_i2c() {
    echo -n "$DEVICE" > "$I2C_DRIVER/unbind" || return 1
    sleep 1
    echo -n "$DEVICE" > "$I2C_DRIVER/bind" || return 1
    [ -e "$I2C_DRIVER/$DEVICE" ]
  }

  # INFO: Fallback 1: rebind only the HID layer, leaving I2C-HID untouched.
  #       The kernel suffixes the id with an instance counter that is bumped on
  #       every re-probe, so match the stable `bus:vendor:product` prefix.
  reset_hid() {
    [ -n "$HID_ID" ] || return 1

    local candidates=("$HID_DRIVER/$HID_ID".*)
    if [ ! -e "''${candidates[0]}" ] || [ "''${#candidates[@]}" -ne 1 ]; then
      return 1
    fi
    local hid_device
    hid_device=$(basename "''${candidates[0]}")

    echo -n "$hid_device" > "$HID_DRIVER/unbind" || return 1
    sleep 1
    echo -n "$hid_device" > "$HID_DRIVER/bind" || return 1
    [ -e "$HID_DRIVER/$hid_device" ]
  }

  # INFO: Fallback 2: reload the HID driver, which re-probes every device it
  #       handles.
  reset_module() {
    modprobe -r hid_multitouch || return 1
    sleep 1
    modprobe hid_multitouch
  }

  if reset_i2c; then
    echo "re-probed $DEVICE"
  elif reset_hid; then
    echo "rebound $HID_ID"
  elif reset_module; then
    echo "reloaded hid_multitouch"
  else
    echo "touchpad-reset: failed to revive $DEVICE" >&2
    exit 1
  fi
''
