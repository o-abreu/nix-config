{
  programs.opencode = {
    settings.agent.integrity-audit = {
      mode = "subagent";
      description = "Claim-to-reference alignment audit of one draft: every claim traced to a source or the draft's own data (ARS academic-pipeline). Returns the integrity report; does not edit.";
      steps = 30;
      permission = {
        "edit" = "deny";
        "webfetch" = "deny";
        "websearch" = "deny";
        bash."python3 *" = "allow";
      };
    };
    agents.integrity-audit = ./role.md;
  };
}
