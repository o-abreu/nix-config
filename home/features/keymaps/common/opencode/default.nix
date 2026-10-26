{
  programs = {
    opencode.cli.keybinds = {
      "agent.cycle" = "tab";
      "agent.cycle.reverse" = "shift+tab";

      # Session tabs: alt+left/right, keeping the ctrl alternatives.
      "session.tab.next" = "ctrl+tab,alt+right";
      "session.tab.previous" = "ctrl+shift+tab,alt+left";

      # Conversation scroll: alt+up/down mirror the defaults.
      "session.half.page.up" = "ctrl+alt+u,alt+up";
      "session.half.page.down" = "ctrl+alt+d,alt+down";

      # INFO: A keybind replaces its whole default list, and the defaults bind
      # alt+left/right to word movement in the prompt (shadowing the session
      # tab bindings above). Redefine both without the alt+arrow alternatives.
      "input.word.forward" = "alt+f,ctrl+right";
      "input.word.backward" = "alt+b,ctrl+left";
    };
    cheatsheet.entries.opencode = ./cheat/opencode.cheat.md;
  };
}
