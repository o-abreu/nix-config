# INFO: Asta research skills from github:allenai/asta-plugins. The plugin
# ships Claude-Code manifests and hooks that opencode does not understand, so
# only the `skills/` trees are vendored -- same pattern as
# `../tools/pdf/default.nix`. The `asta` CLI itself is `pkgs.asta` (pkgs/asta).
#
# Asta is reserved for the `research` primary agent: the permissions below
# deny every vendored skill and the `asta` CLI globally, and
# `../../agents/primary/research.nix` re-allows them for that agent only.
{
  pkgs,
  inputs,
  lib,
  ...
}: let
  skills = import ./_skills.nix {
    inherit lib inputs;
    plugins = [
      "asta-tools"
      "asta-flows"
      "asta-assistant"
    ];
  };
in {
  home.packages = [pkgs.asta];

  programs.opencode = {
    # Binaries the skills invoke directly through the agent's Bash. `uv` is used
    # by the skills as `uv run --with <pypi dep> ...`, so it fetches ephemeral
    # Python deps at runtime.
    extraPackages = with pkgs; [
      jq # result browsing and hook scripts
      uv # `uv run --with pyyaml|playwright ...`
      python3 # pdf-download Phase 1, chunking scripts
      quarto # workspace / literature-report rendering (overlays/quarto.nix)
    ];

    settings.permission = {
      skill = skills |> map (s: s.name) |> lib.flip lib.genAttrs (_: "deny");
      bash."asta *" = "deny";
    };
  };

  xdg.configFile =
    skills
    |> map
    (s: {
      name = "opencode/skills/${s.name}";
      value.source = s.path;
    })
    |> builtins.listToAttrs;
}
