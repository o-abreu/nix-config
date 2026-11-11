# INFO: The `research` primary agent.
#
# Skill allow-list, in three groups:
#
#   * literature   -- find-literature, literature-report, paper-lookup,
#                     semantic-scholar, local-paper-index, pdf-download,
#                     pdf-extraction, generate-theories, check-claims,
#                     scientific-critical-thinking
#   * project work -- brainstorm, plan-work, do-work, review-plan, review-work,
#                     run, save-work (a closed set: `run` dispatches to
#                     do-work/plan-work, `do-work` hands off to review-work then
#                     save-work)
#   * plumbing     -- asta-cli, asta-documents, asta-flows, artifacts, workspace,
#                     zotero-cli
#
# Denied on purpose: `analyze-data` (uploads the dataset to a hosted workspace),
# `autodiscovery` (separate MCTS discovery platform), `experiment` (Panda; we do
# not use it), `feedback` (meta, about the tool rather than the research).
{lib, ...}: let
  skills = [
    "asta-cli"
    "asta-documents"
    "asta-flows"
    "artifacts"
    "brainstorm"
    "check-claims"
    "do-work"
    "find-literature"
    "generate-theories"
    "literature-report"
    "local-paper-index"
    "paper-lookup"
    "pdf-download"
    "pdf-extraction"
    "plan-work"
    "review-plan"
    "review-work"
    "run"
    "save-work"
    "scientific-critical-thinking"
    "semantic-scholar"
    "workspace"
    "zotero-cli"
  ];
in {
  programs.opencode = {
    settings.agent.research = {
      mode = "primary";
      description = "Research collaborator: frames, plans, executes, reviews and writes up research.";

      permission = {
        "kaggle_*" = "allow";
        "context7_*" = "allow";
        "libgen_*" = "allow";

        bash = {
          "asta *" = "allow";
          "python3 *" = "allow";
          "zotero-cli *" = "allow";
          "zotero-mcp *" = "allow";
          "git status*" = "allow";
          "git add *" = "allow";
          "git diff*" = "allow";
          "git commit *" = "allow";
          "git log*" = "allow";
        };

        skill = lib.genAttrs skills (_: "allow");

        # Subagents do not inherit permissions; this only grants launch.
        subagent = {
          paper-extractor = "allow";
          # ARS roles (subagents/ars/): the separations that matter are context
          # boundaries. Their role files read the vendored ARS agent specs,
          # which do not exist until the ARS vendoring lands -- a launch before
          # that fails cleanly as "unreadable".
          peer-reviewer = "allow";
          citation-audit = "allow";
          integrity-audit = "allow";
          screener-reviewer = "allow";
        };
      };
    };

    agents.research = ./role.md;
  };
}
