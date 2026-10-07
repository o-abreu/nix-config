{inputs, ...}: {
  imports = [./_shell.nix];
  programs.opencode.settings.agent.plan.permission."context7_*" = "allow";
  xdg.configFile."opencode/skills/context7/SKILL.md".source = "${inputs.upstash-context7}/skills/context7-mcp/SKILL.md";
}
