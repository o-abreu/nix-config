# INFO: Launch presenterm in a dedicated, fullscreen WezTerm window.
#
# presenterm is a TUI. Run directly, it inherits whatever terminal you happen to
# be sitting in -- your editor font size, your tab bar, your window geometry.
# That is fine for skimming a deck, wrong for standing in front of an audience.
# So: spawn a throwaway WezTerm sized for the back row, tag it with a known
# `--class` so the compositor can find it, and fullscreen it.
#
# Usage: presenter [-s|--font-size SIZE] [presenterm-options...] <markdown-file>
#
# `--font-size` is consumed here; every other argument is forwarded verbatim to
# presenterm. The LAST argument is the presentation file, resolved with realpath
# so it survives the window launch.
#
# `presenterm` itself is provided by the wrapper in `default.nix`, which lets the
# launcher be pointed at the Home-Manager-configured build.

font_size=21
presenterm_args=()

while [[ $# -gt 0 ]]; do
  case "$1" in
  -s | --font-size)
    font_size="$2"
    shift 2
    ;;
  *)
    presenterm_args+=("$1")
    shift
    ;;
  esac
done

if [[ ${#presenterm_args[@]} -eq 0 ]]; then
  echo "Usage: $0 [--font-size SIZE] [presenterm-options...] <markdown-file>" >&2
  exit 1
fi

last_idx=$((${#presenterm_args[@]} - 1))
markdown_file="${presenterm_args[$last_idx]}"

if [[ ! -f "$markdown_file" ]]; then
  echo "Error: File '$markdown_file' not found" >&2
  echo "Usage: $0 [--font-size SIZE] [presenterm-options...] <markdown-file>" >&2
  exit 1
fi

markdown_file=$(realpath "$markdown_file")
presenterm_args[last_idx]="$markdown_file"

# shellcheck disable=SC2016
# INFO: The `sleep 0.5` lets WezTerm settle its window (and apply the --config
# overrides) before presenterm draws, otherwise the TUI can render at the old
# geometry. On failure the window is held open so the error is readable instead
# of vanishing. `--cwd` keeps the caller's directory, which presenterm needs to
# resolve relative image/partial paths.
wezterm \
  --config "enable_tab_bar=false" \
  --config "font_size=${font_size}" \
  start \
  --class "presenterm" \
  --cwd "$(pwd)" \
  -- bash -c 'sleep 0.5; presenterm "$@"; rc=$?; if [ $rc -ne 0 ]; then echo "presenterm failed with exit code $rc"; read -n1 -p "Press any key to close..."; fi; exit $rc' _ "${presenterm_args[@]}" &

wezterm_pid=$!

# INFO: WezTerm gives no handle on the new toplevel, so poll Hyprland for the
# window carrying our `--class`, then focus and fullscreen it. Bounded to ~2s;
# if it never appears we simply skip the focus step rather than hang.
for _ in $(seq 1 20); do
  addr=$(hyprctl clients -j | jq -r '[.[] | select(.class == "presenterm") | .address][0] // empty')
  if [[ -n "$addr" && "$addr" != "null" ]]; then
    hyprctl dispatch focuswindow "address:${addr}"
    hyprctl dispatch fullscreen 1
    break
  fi
  sleep 0.1
done

# INFO: Block until the presentation window closes, so `presenter` behaves like
# a foreground command (the shell prompt returns only after the talk ends).
wait "$wezterm_pid" 2>/dev/null || true
