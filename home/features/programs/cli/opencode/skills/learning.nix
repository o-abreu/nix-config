# INFO: Pedagogical skills for the `learn` primary agent.
#
# Only the parts OpenCode understands are mounted. Both upstream trees also ship
# Claude Code slash commands (`commands/`) and frontmatter keys that OpenCode
# ignores (`user-invocable`, `allowed-tools`, ...), so each skill is copied into
# a normalised derivation containing just:
#
#   * `SKILL.md` with `name` and `description` as the only frontmatter fields;
#   * `references/`, when the upstream skill ships one (read on demand).
#
# Both sources are MIT licensed. They are denied globally here and re-allowed
# only for `learn` (agents/primary/learn/default.nix), the same pattern as the
# Asta skills in tools/asta/default.nix.
{
  pkgs,
  inputs,
  lib,
  ...
}: let
  skillNames = [
    "socratic"
    "feynman"
    "explaining-code"
  ];

  # Rewrites the frontmatter down to the fields OpenCode reads. Fails on a block
  # scalar (`description: >`) so an upstream reformat cannot silently drop the
  # description instead of being handled here.
  normalize = {
    name,
    src,
  }:
    pkgs.runCommand "opencode-skill-${name}" {} ''
      mkdir -p $out
      awk '
        BEGIN { fm = 0 }
        /^---[[:space:]]*$/ { fm++; if (fm <= 2) print; next }
        fm == 1 && /^(name|description):[[:space:]]*[>|]/ {
          print "block scalar frontmatter is not supported by normalize: ${src}" > "/dev/stderr"
          exit 1
        }
        fm == 1 { if ($0 ~ /^(name|description):/) print; next }
        { print }
      ' ${src}/SKILL.md > $out/SKILL.md

      if [ -d ${src}/references ]; then
        cp -r ${src}/references $out/references
      fi
    '';
in {
  programs.opencode.settings.permission.skill =
    lib.genAttrs skillNames (_: "deny");

  xdg.configFile = {
    "opencode/skills/socratic".source = normalize {
      name = "socratic";
      src = inputs.neurofoo-agent-skills + "/socratic";
    };

    "opencode/skills/feynman".source = normalize {
      name = "feynman";
      src = inputs.neurofoo-agent-skills + "/feynman";
    };

    "opencode/skills/explaining-code".source = normalize {
      name = "explaining-code";
      src = inputs.patricio-skills + "/foundation/explaining-code";
    };
  };
}
