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

  xdg.configFile."opencode/skills/zotero-cli".source =
    inputs.zotero-mcp + "/src/zotero_mcp/skills/zotero-cli";
}
