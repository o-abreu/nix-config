# INFO: Schema-filling subagent for `research`.
#
# Deliberately narrow. It does not search, fetch, appraise, or synthesize -- it
# turns one paper that is already in the Zotero library into a record, with a
# page and a verbatim quote per field. The parent owns the schema, because the
# schema is a research decision and any fixed one is necessarily lossy.
#
# Why not the built-in `general` or `explore`: subagents do not inherit the
# parent's permissions, and `general` falls back to the global map, which denies
# `zotero-cli`. `explore` is a Morph code-search wrapper.
#
# Why `zotero-cli` and not `pdftotext`, and why no asta/web access: the library
# is the boundary. Keeping the worker inside it means it can never cite
# something the user does not have, and it gets page boundaries plus the
# garbled-page report for free -- which is what makes `page` + `quote`
# checkable at all. It also cannot go hunting for a paper the library lacks.
{
  programs.opencode = {
    settings.agent.paper-extractor = {
      mode = "subagent";
      description = "Fills a fixed schema from one paper already in the Zotero library, quoting the page for every field. Does not summarize, search, or fetch.";

      # One paper, a handful of `read` calls, maybe one image fallback. Anything
      # past this is a mis-scoped task that should return to the parent.
      steps = 14;

      permission = {
        "edit" = "deny";
        "webfetch" = "deny";
        "websearch" = "deny";
        bash."zotero-cli *" = "allow";
        skill."zotero-cli" = "allow";
      };
    };

    agents.paper-extractor = ./role.md;
  };
}
