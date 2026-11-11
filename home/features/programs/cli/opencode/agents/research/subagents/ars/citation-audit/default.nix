{
  programs.opencode = {
    settings.agent.citation-audit = {
      mode = "subagent";
      description = "Audits the reference list and in-text citations of one draft against the Zotero library, quoting pages (ARS academic-paper Phase 5a). Does not edit, search, or fetch.";
      steps = 20;
      permission = {
        "edit" = "deny";
        "webfetch" = "deny";
        "websearch" = "deny";
        bash."zotero-cli *" = "allow";
        skill."zotero-cli" = "allow";
      };
    };
    agents.citation-audit = ./role.md;
  };
}
