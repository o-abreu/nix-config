{lib, ...}: {
  programs.opencode.settings.agent.learn.permission = {
    # A tutor proposes changes; it does not apply them.
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
        "asta papers *"
        "asta literature *"
        "asta pdf-extraction *"
        "zotero-cli config"
        "zotero-cli db status"
        "zotero-cli search *"
        "zotero-cli get *"
        "zotero-cli read *"
        "zotero-cli --json search *"
        "zotero-cli --json get *"
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
      ]
      (_: "allow");
  };
}
