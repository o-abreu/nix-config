{ unit }:
# bash
''
  UNIT="${unit}"

  # INFO: Runs entirely as the invoking user: polkit authorises the unit start
  #       (see security.polkit.extraConfig), so there is no sudo, no setuid
  #       helper on PATH, and notify-send keeps the session bus.
  notify() {
    notify-send "$@" 2>/dev/null || true
  }

  if output=$(systemctl start "$UNIT" 2>&1); then
    notify "Touchpad" "Reset"
  else
    notify -u critical "Touchpad" "Reset failed: $output"
    echo "$output" >&2
    exit 1
  fi
''
