{
  programs.opencode = {
    settings.agent.screener-reviewer = {
      mode = "subagent";
      description = "Screens one batch of records against supplied eligibility criteria as a blinded reviewer (modes: ta-screen, ft-screen, adjudicate). Returns ordered exclusion codes; does not edit.";
      steps = 20;
      permission = {
        "edit" = "deny";
        "webfetch" = "deny";
        "websearch" = "deny";
      };
    };
    agents.screener-reviewer = ./role.md;
  };
}
