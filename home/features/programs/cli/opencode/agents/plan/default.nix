{inputs, ...}: {
  imports = [./_shell.nix];

  programs.opencode.settings.agent.plan = {
    permission = {
      "context7_*" = "allow";

      # Skill discovery is plan-only; `../../tools/skill-discovery/default.nix`
      # denies these globally. Staging and removal change what the agent can
      # load, so both still prompt before running.
      skills_discover = "allow";
      skills_install = "ask";
      skills_remove = "ask";
      skill."find-skills" = "allow";
      bash."skills *" = "allow";
    };
  };

  xdg.configFile."opencode/skills/context7/SKILL.md".source = "${inputs.upstash-context7}/skills/context7-mcp/SKILL.md";
}
