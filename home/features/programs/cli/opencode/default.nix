{
  programs = {
    fish.shellAbbrs.op = "opencode";
    opencode = {
      enable = true;
      # INFO: TUI-client preferences previously owned by the app-side
      # `~/.config/opencode/cli.json` (written by the TUI's "Open settings"),
      # migrated declaratively when Home Manager took over cli.json (see
      # stylix/astrodark-theme/overrides/opencode.nix for the tui.json ->
      # cli.json migration). Server-side settings below stay in opencode.json.
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
