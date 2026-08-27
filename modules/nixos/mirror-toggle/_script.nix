{ cfg }:
# bash
''
  PRIMARY="${cfg.main}"

  # INFO: Mirror state is detected live from Hyprland, so no state file is needed.
  #       The toggle counts as "mirrored" whenever any enabled external monitor
  #       reports a mirrorOf target.
  EXTERNALS=()
  MIRRORED=false
  while read -r name mir; do
    if [ "$name" = "$PRIMARY" ]; then
      continue
    fi
    EXTERNALS+=("$name")
    if [ "$mir" != "none" ]; then
      MIRRORED=true
    fi
  done < <(hyprctl -j monitors all | jq -r '.[] | select(.disabled == false) | "\(.name) \(.mirrorOf)"')

  if [ "''${#EXTERNALS[@]}" -eq 0 ]; then
    notify-send "Display Mode" "No external display detected"
    exit 0
  fi

  if [ "$MIRRORED" = true ]; then
    # INFO: Switch back to Extended mode - disable then re-enable each external
    #       monitor so Hyprland re-applies its default layout
    for ext in "''${EXTERNALS[@]}"; do
      hyprctl keyword monitor "$ext,disable"
      hyprctl keyword monitor "$ext,preferred,auto,1"
    done
    notify-send "Display Mode" "Screen Extended"
  else
    # INFO: Mirror the primary display onto every connected external monitor
    for ext in "''${EXTERNALS[@]}"; do
      hyprctl keyword monitor "$ext,preferred,auto,1,mirror,$PRIMARY"
    done
    notify-send "Display Mode" "Screen Mirrored"
  fi
''
