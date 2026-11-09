{lib, ...}: {
  programs.opencode.settings.agent.learn.permission = {
    edit = "deny";
    webfetch = "allow";
    "nixos_*" = "allow";
    bash =
      {"*" = "ask";}
      // lib.genAttrs
      [
        "git diff*"
        "git log*"
        "git show*"
        "git status*"
        "git blame*"
        "rg *"
        "fd *"
        "ls *"
        "tree *"
        "cat *"
        "bat *"
        "wc *"
        "jq *"
        "pdftotext *"
        "pdfinfo *"
        "pdftoppm *"
        "python3 *"
        "asta papers *"
        "asta literature *"
        "asta pdf-extraction *"
        "zotero-cli config"
        "zotero-cli db status"
        "zotero-cli db update *"
        "zotero-cli search *"
        "zotero-cli get *"
        "zotero-cli outline *"
        "zotero-cli read *"
        "zotero-cli --json-schema"
        "zotero-cli --json config *"
        "zotero-cli --json db status *"
        "zotero-cli --json db update *"
        "zotero-cli --json search *"
        "zotero-cli --json get *"
        "zotero-cli --json outline *"
        "zotero-cli --json read *"
      ]
      (_: "allow");
    skill =
      lib.genAttrs
      [
        "socratic"
        "feynman"
        "explaining-code"
        "find-literature"
        "semantic-scholar"
        "zotero-cli"
        "pdf-extraction"
        "sympy"
      ]
      (_: "allow");
  };
}
