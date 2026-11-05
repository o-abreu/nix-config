# INFO: Shared normaliser for vendored upstream skills.
#
# OpenCode reads only `name` and `description` from SKILL.md frontmatter, and
# discovers supporting files relative to the skill directory. Upstream trees
# ship extra frontmatter keys that mean something to other harnesses
# (`allowed-tools`, `user-invocable`, `compatibility`, `metadata`, ...) and
# sometimes Claude Code slash commands under `commands/`. Each skill is copied
# into a derivation containing:
#
#   * `SKILL.md` with `name` and `description` as the only frontmatter fields;
#   * every sibling directory except `commands/`, because skills such as
#     paper-lookup dispatch into bundled `scripts/` and read `references/` on
#     demand. Dropping `scripts/` would mount a skill whose instructions
#     reference files that do not exist.
#
# `_`-prefixed so import-tree does not auto-import it.
{pkgs, ...}: {
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

  for d in ${src}/*/; do
    [ -e "$d" ] || continue
    b=''${d%/}
    b=''${b##*/}
    if [ "$b" = commands ]; then continue; fi
    cp -r "$d" $out/"$b"
  done
''
