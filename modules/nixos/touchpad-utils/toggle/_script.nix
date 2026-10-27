{ cfg }:
# bash
''
  DEVICE="${cfg.name}"

  STATE=$(hyprctl -j getoption "device[$DEVICE]:enabled" | jq .int 2>/dev/null)
  if [ -z "$STATE" ]; then
    notify-send "Touchpad" "Device not found: $DEVICE"
    exit 1
  fi

  NEW=$((1 - STATE))
  hyprctl keyword "device[$DEVICE]:enabled" "$NEW"

  if [ "$NEW" = 1 ]; then
    notify-send "Touchpad" "Enabled"
  else
    notify-send "Touchpad" "Disabled"
  fi
''
