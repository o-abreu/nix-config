# INFO: Scientific tooling skills vendored from k-dense-ai/scientific-agent-skills
# (MIT). Denied globally here and re-allowed per agent:
#
#   * `sympy`                       -> learn   (exact algebra and linear algebra)
#   * `paper-lookup`                -> research (18 scholarly APIs, provenance)
#   * `scientific-critical-thinking` -> research (GRADE, Cochrane RoB)
#
# `paper-lookup` ships a `scripts/` directory that its SKILL.md dispatches into,
# which is why the shared normaliser copies sibling directories and not only
# `references/` -- mounting it with references alone would leave instructions
# pointing at files that do not exist.
#
# Selection rationale: `literature-review` and `citation-management` were left
# out because they duplicate `find-literature` / `literature-report` and
# `zotero-cli` respectively, and drag in Pandoc/XeLaTeX or `scholarly`.
{
  pkgs,
  inputs,
  lib,
  ...
}: let
  sources = lib.genAttrs
    [
      "sympy"
      "paper-lookup"
      "scientific-critical-thinking"
    ]
    (name: inputs.k-dense-agent-skills + "/skills/${name}");
  normalize = import ./_normalize.nix {inherit pkgs;};
in {
  programs.opencode = {
    settings.permission.skill =
      lib.genAttrs (builtins.attrNames sources) (_: "deny");
    python.withPackages = [pkgs.python3Packages.sympy];
  };

  xdg.configFile = lib.mapAttrs' (name: src:
    lib.nameValuePair "opencode/skills/${name}" {
      source = normalize {inherit name src;};
    })
  sources;
}
