# INFO: Extends the upstream blink-cmp nixvim module with a declarative
# registration point for completion sources.
#
# `extraSources` is declared outside `plugins.blink-cmp.settings` on purpose:
# everything under `settings` is serialized verbatim into
# `require('blink.cmp').setup(...)`. Provider definitions still live under
# `plugins.blink-cmp.settings.sources.providers.<id>`; each feature module sets
# both that and the source ids it contributes here.
#
# This is a nixvim module: import it into `programs.nixvim.imports` under Home
# Manager, or into the top-level `imports` of a standalone nixvim configuration.
{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.plugins.blink-cmp.extraSources = mkOption {
    default = { };
    description = ''
      Completion sources contributed by feature modules, grouped by the context
      in which blink.cmp should use them.

      Provider definitions are still declared under
      `plugins.blink-cmp.settings.sources.providers`.
    '';
    type = types.submodule {
      options = {
        default = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Source ids appended to the default source list.";
        };

        comment = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Source ids appended when the cursor is inside a comment.";
        };

        gitcommit = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Source ids appended in `gitcommit` buffers.";
        };
      };
    };
  };
}
