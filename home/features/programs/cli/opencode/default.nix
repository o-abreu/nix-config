{
  programs = {
    fish.shellAbbrs.op = "opencode";
    opencode = {
      enable = true;
      cli = {
        animations = true;
        diffs.wrap = "word";
        session = {
          sidebar = "auto";
          scrollbar = false;
          thinking = "hide";
        };
      };
      settings = {
        autoupdate = false;
        default_agent = "plan";
        experimental.todo = true;
        lsp = true;
        policies = [
          {
            action = "tool.use";
            resource = "read:*.lic";
            effect = "deny";
          }
          {
            action = "tool.use";
            resource = "edit:*.lic";
            effect = "deny";
          }
        ];
        permission = {
          bash."sudo *" = "deny";
          external_directory."/tmp/**" = "allow";
        };
      };
    };
  };
}
