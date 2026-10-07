{
  inputs,
  lib,
  ...
}: let
  astaSkills =
    import ../../tools/asta/_skills.nix {
      inherit lib inputs;
      plugins = [
        "asta-tools"
        "asta-flows"
        "asta-assistant"
      ];
    }
    |> map (s: s.name);
in {
  programs.opencode = {
    settings.agent.research = {
      mode = "primary";
      permission = {
        "kaggle_*" = "allow";
        "context7_*" = "allow";
        bash."asta *" = "allow";
        bash."zotero-cli *" = "allow";
        bash."zotero-mcp *" = "allow";
        skill =
          {"zotero-cli" = "allow";}
          // lib.genAttrs astaSkills (_: "allow");
      };
    };

    agents.research = ''
      You are a scientific researcher. When answering a question, always:

      - backup your answer on actual data or literature;
      - cite your sources.
    '';
  };
}
