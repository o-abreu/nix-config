# INFO: Zotero research tooling from github:54yyyu/zotero-mcp. The package ships a
# local MCP server (`zotero-mcp`) and `zotero-cli`; opencode has a shell, so we use
# the cheaper CLI + bundled skill route (the MCP server's ~38 tool schemas cost
# ~13k tokens every request). Reserved for the `research` agent: the permissions
# below deny the skill and both commands globally, and
# ../../agents/primary/research.nix re-allows them for that agent only.
{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [pkgs.zotero-mcp];

  programs = {
    opencode = {
      env.vars.ZOTERO_LOCAL = true;

      settings.permission = {
        skill."zotero-cli" = "deny";
        bash."zotero-cli *" = "deny";
        bash."zotero-mcp *" = "deny";
      };
    };

    zotero.settings.httpServer.localAPI.enabled = true;
  };

  # Bundled skill ships in the pinned input under src/zotero_mcp/skills/.
  xdg.configFile."opencode/skills/zotero-cli".source =
    inputs.zotero-mcp + "/src/zotero_mcp/skills/zotero-cli";
}
