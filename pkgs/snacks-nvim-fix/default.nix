# Patch snacks.nvim's win.lua to guard against stale parent window ids
# during nvim_open_win.
#
# Root cause: snacks layout.lua:update_win copies `win = self.root.win`
# into each layout window's opts on every update(). If the root window
# was closed or replaced mid-update (a race when toggling explorer
# preview with fast focus switches), opts.win holds a dead id and
# nvim_open_win throws "Invalid window id: NNN".
#
# The fix: in open_win, if relative="win" and the parent window is
# invalid, fall back to relative="editor" so the float opens anyway.
# This is a no-op when the parent is valid.
#
# Upstream bug: snacks.nvim#1348 (and related issues) — still present
# on master as of 2026-08. The set_title path has this guard, but
# open_win does not.
{ snacks-nvim }:
snacks-nvim.overrideAttrs (old: {
  patches = (old.patches or []) ++ [
    ./win-guard.patch
  ];
})
