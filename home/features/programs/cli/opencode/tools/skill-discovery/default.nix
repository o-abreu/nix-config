# INFO: Skill discovery from arbitrary online git repositories.
#
# `pkgs.skills` (github:vercel-labs/skills) does the fetching, authentication
# and lockfile bookkeeping; `plugin.ts` adds the in-session glue:
#
#   * `skills_discover` / `skills_install` / `skills_remove` tools;
#   * staged skills registered through `ctx.skill.transform`, so a new skill is
#     usable in the same session instead of after a restart;
#   * `autoinvoke` disabled on everything it registers, so a discovered skill is
#     never advertised to the model and must be loaded by exact ID.
#
# Installs are staged under `~/.local/share/opencode/skill-discovery`, which is
# not a directory OpenCode discovers skills from. A global install would land in
# `~/.agents/skills` and be advertised before review, so `plugin.ts` never
# passes `-g`.
#
# This complements, and does not replace, the pinned inputs in `../pdf.nix` and
# `../asta/default.nix`: discovery is disposable, promotion to a flake input is
# the reviewed path.
#
# Discovery is reserved for the `plan` primary agent: the permissions below deny
# the tools, the `skills` CLI and the `find-skills` skill globally, and
# `../../agents/primary/plan/default.nix` re-allows them for that agent only.
{pkgs, ...}: let
  # Upstream's own `find-skills` skill, vendored from the source nixpkgs pins for
  # the CLI rather than copied into this repo. Same version, so the instructions
  # can never describe flags a different `skills` binary does not have.
  find-skills =
    pkgs.runCommand "find-skills" {} ''
      mkdir -p $out
      cp -r ${pkgs.skills.src}/skills/find-skills/. $out/
      chmod -R u+w $out

      # Upstream documents `npx skills`; the CLI is already in extraPackages.
      substituteInPlace $out/SKILL.md --replace-fail 'npx skills' 'skills'

      # Its headline install example uses `-g`, which writes to
      # `~/.agents/skills` and bypasses review. This must run after the
      # substitution above, which is what turns `npx skills` into `skills`.
      substituteInPlace $out/SKILL.md \
        --replace-fail 'skills add <owner/repo@skill> -g -y' \
        'skills add <owner/repo@skill>'

      substituteInPlace $out/SKILL.md \
        --replace-fail 'The `-g` flag installs globally (user-level) and `-y` skips confirmation prompts.' \
        'The `-y` flag skips confirmation prompts.'
    '';
in {
  programs.opencode = {
    extraPackages = [pkgs.skills];

    # Denied globally; the `plan` agent re-allows them (see the header). `skills`
    # is on PATH through `extraPackages`, so the CLI is denied too — otherwise
    # `skills add` would be the same capability as `skills_install`.
    settings.permission = {
      skills_discover = "deny";
      skills_install = "deny";
      skills_remove = "deny";
      skill."find-skills" = "deny";
      bash."skills *" = "deny";
    };
  };

  xdg.configFile = {
    # Direct `.ts` files under `~/.config/opencode/plugins/` load automatically.
    "opencode/plugins/skill-discovery.ts".source = ./plugin.ts;

    # Vetted upstream skill; the local rules that upstream cannot know live in
    # the tool descriptions in `plugin.ts`, which are always in context.
    "opencode/skills/find-skills".source = find-skills;
  };
}
