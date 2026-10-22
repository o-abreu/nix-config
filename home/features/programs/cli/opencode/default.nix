{
  programs = {
    fish.shellAbbrs.op = "opencode";
    opencode = {
      enable = true;
      settings = {
        autoupdate = false;
        default_agent = "plan";
        lsp = true;
        permission = {
          bash."sudo *" = "deny";
          external_directory."/tmp/**" = "allow";
        };
      };
      env.vars.OPENCODE_EXPERIMENTAL = true;
    };
  };
}
