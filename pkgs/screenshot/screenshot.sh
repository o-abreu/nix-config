# INFO: Interactive screenshot tool for Hyprland.
#
# Modes:
#   auto (default) - one slurp overlay, three behaviors:
#     * click a window      -> captures that window
#     * click empty desktop -> captures the whole monitor
#     * click and drag      -> captures the drawn region
#   active - capture the focused window (grimblast)
#   output - capture the whole current output (grimblast)
#   area   - select a region with grimblast's own slurp
#
# `auto` feeds slurp the rectangles of every visible client followed by every
# monitor's full rectangle. Slurp highlights the smallest predefined rectangle
# under the cursor and a plain click selects it, so client rects win over the
# monitor-sized fallbacks. A click+drag ignores the predefined rects and
# yields a free-form region, classified afterwards by matching the result
# against the rect lists. A drag that happens to land exactly on a
# window/monitor rect captures the same pixels either way.

outputDir="$(xdg-user-dir PICTURES)/Screenshots"
outputFile="snapshot_$(date +%Y-%m-%d_%H-%M-%S).png"
outputPath="$outputDir/$outputFile"
mkdir -p "$outputDir"

mode=${1:-auto}

# Hyprland reports monitor width/height in physical pixels while client
# geometry is logical; divide by scale to match slurp's logical coordinates.
monitor_rects() {
  jq -r '
    .[]
    | select(.mirrorOf == "none")
    | "\(.x),\(.y) \((.width / .scale | floor))x\((.height / .scale | floor)) output:\(.name)"
  '
}

# Sorted by focusHistoryID so overlapping equal-size windows resolve to the
# most recently focused one.
client_rects() {
  jq -r '
    sort_by(.focusHistoryID)
    | .[]
    | select(.visible and .size[0] > 0 and .size[1] > 0)
    | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1]) client"
  '
}

capture_auto() {
  local rects selection geometry monitorLine
  rects="$(
    {
      hyprctl -j clients | client_rects
      hyprctl -j monitors | monitor_rects
    }
  )"

  selection="$(printf '%s\n' "$rects" | slurp -f '%x %y %w %h' -d -w 1 \
    -b '00000000' -c 'ffffffff' -s 'ffffff30' -B 'ffffff18')" || return 1

  read -r gx gy gw gh <<< "$selection"
  geometry="$gx,$gy ${gw}x${gh}"

  # Classify the selection: exact match against the predefined rect lists.
  if grep -Fxq -- "$geometry client" <<< "$rects"; then
    # A window was clicked: capture its full rectangle.
    grim -g "$geometry" "$outputPath"
  elif monitorLine="$(grep -F -- "$geometry output:" <<< "$rects" | head -n 1)" \
    && [[ -n "$monitorLine" ]]; then
    # Empty desktop was clicked: capture the monitor under the cursor.
    grim -o "${monitorLine##*output:}" "$outputPath"
  else
    # Free-form drag: capture the drawn region.
    grim -g "$geometry" "$outputPath"
  fi

  wl-copy < "$outputPath"
}

captured=false
case "$mode" in
  auto)
    if capture_auto; then
      captured=true
    fi
    ;;
  active)
    if grimblast copysave active "$outputPath"; then
      captured=true
    fi
    ;;
  output)
    if grimblast copysave output "$outputPath"; then
      captured=true
    fi
    ;;
  area)
    if grimblast copysave area "$outputPath"; then
      captured=true
    fi
    ;;
  *)
    echo "Invalid option: $mode"
    echo "Usage: $0 {auto|active|output|area}"
    exit 1
    ;;
esac

if [[ "$captured" == true ]]; then
  recentFile=$(find "$outputDir" -name 'snapshot_*.png' -printf '%T+ %p\n' | sort -r | head -n 1 | cut -d' ' -f2-)
  notify-send "Screenshot" "Your snapshot has been saved." \
    -i video-x-generic \
    -a "Screenshot" \
    -t 7000 \
    -u normal \
    --action="scriptAction:-xdg-open $outputDir=Directory" \
    --action="scriptAction:-xdg-open $recentFile=View"
fi
