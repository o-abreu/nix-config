{
  programs = {
    fish.shellAbbrs.op = "opencode";
    opencode = {
      enable = true;
      settings = {
        autoupdate = false;
        default_agent = "plan";
        server.port = 8765;
        permission.bash."sudo *" = "deny";
      };
      env.vars.OPENCODE_EXPERIMENTAL = true;
    };
  };
}
