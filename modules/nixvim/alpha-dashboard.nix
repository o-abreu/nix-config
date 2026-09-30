# INFO: Extends the upstream alpha nixvim module with a declarative registry of
# dashboard buttons.
#
# Each keymap owns its entry: files that declare a keymap with an
# `options.desc` can also register a dashboard button that points at the same
# keymap. The alpha layout module (`plugins/ui/alpha/default.nix`) resolves
# each entry's key/action from `config.programs.nixvim.keymaps` by `desc`, so
# the dashboard stays in sync with whatever keymap is actually active.
#
# Ordering uses the Nix module system's list-definition priorities rather than
# a hand-maintained sort key: wrap a contribution in `lib.mkOrder N` (or
# `lib.mkBefore`/`lib.mkAfter`). `types.listOf` stably sorts definitions by
# order-priority before concatenating, so priorities pin a module's block to a
# position in the merged list. Reserved bands:
#
#   100        New/Open file (first)
#   200        Smart Find Files (second)
#   300-1899   middle buttons (default 1000; mkBefore=500, mkAfter=1500)
#   1900       Change header image (second-to-last)
#   2000       Quit Nixvim (last)
#
# The four pinned slots are asserted in `plugins/ui/alpha/default.nix`, so a
# future contributor using an out-of-band priority fails evaluation loudly.
#
# This is a nixvim module: import it into `programs.nixvim.imports` under Home
# Manager, or into the top-level `imports` of a standalone nixvim configuration.
{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.plugins.alpha.dashboardButtons = mkOption {
    default = [ ];
    description = ''
      Dashboard buttons contributed by keymap modules. Each entry must match a
      keymap declared elsewhere by its `desc`.
    '';
    type = types.listOf (types.submodule {
      options = {
        desc = mkOption {
          type = types.str;
          description = "The keymap `desc` this button renders.";
        };

        icon = mkOption {
          type = types.str;
          description = "Icon glyph shown next to the keymap description.";
        };

        key = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Explicit alpha shortcut, e.g. `"SPC c i"`. When set together with
            `action`, the button is rendered verbatim instead of being resolved
            from a keymap by `desc`.
          '';
        };

        action = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Explicit Vim command string, e.g. `":AlphaAsciiNext<CR>"`. Must be
            set together with `key`.
          '';
        };
      };
    });
  };
}