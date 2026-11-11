{
  programs.opencode = {
    settings.agent.peer-reviewer = {
      mode = "subagent";
      description = "Five-dimension simulated peer review of one draft on disk (ARS academic-paper Phase 6). Receives the draft path and review-target context; returns the review report. Does not edit.";
      steps = 30;
      permission = {
        "edit" = "deny";
        "webfetch" = "deny";
        "websearch" = "deny";
      };
    };
    agents.peer-reviewer = ./role.md;
  };
}
