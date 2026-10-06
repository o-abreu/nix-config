{
  programs.nixvim.plugins.nvim-lightbulb = {
    enable = true;
    lazyLoad.settings.event = "DeferredUIEnter";

    settings = {
      # INFO: ruff answers `textDocument/codeAction` on *every* line with two
      # document-level actions (`source.fixAll.ruff`, `source.organizeImports.ruff`).
      # With no `action_kinds` allow-list they come back, and since the bulb is
      # drawn on `CursorHold` it followed the cursor and lit up on every line. A
      # whole-document action is not position specific, so it cannot justify a
      # cursor-following indicator: drop `source.*` and keep the bulb for real
      # per-cursor `quickfix` / `refactor` actions.
      #
      # The signature is `filter(client_name, action)`. A server returning a bare
      # `Command` has no `kind`, so `action.kind or ""` keeps it.
      #
      # `__raw` must stay a single function *expression*: nixvim splices it in as
      # `filter = <content>`, so a multi-statement block would be a syntax error.
      filter.__raw =
        # lua
        ''
          function(_, action)
            return not (action.kind or ""):match("^source%.")
          end
        '';

      autocmd = {
        enabled = true;
        updatetime = 200;
      };

      line = {
        enabled = true;
      };

      number = {
        enabled = true;
      };

      sign = {
        enabled = true;
        text = "󰌶";
      };

      status_text = {
        enabled = true;
        text = "󰌶";
      };
    };
  };
}
