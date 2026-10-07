{
  programs = {
    fish.shellAbbrs.op = "opencode";
    opencode = {
      enable = true;
      settings = {
        autoupdate = false;
        default_agent = "plan";
        lsp = true;
        server.port = 8765;
        permission = {
          bash."sudo *" = "deny";
          external_directory."/tmp/**" = "allow";
        };
      };
      env.vars.OPENCODE_EXPERIMENTAL = true;
    };
  };
}
