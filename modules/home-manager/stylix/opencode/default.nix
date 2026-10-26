{
  config,
  lib,
  ...
}: {
  # INFO: This flake tracks stylix master, which is mapped against nixpkgs
  # unstable and therefore OpenCode >= 2, where tui.json is legacy: OpenCode 2
  # reads a single global `cli.json` and only migrates an existing tui.json
  # when cli.json is absent. Neutralize the upstream target's `tui` authoring
  # and select the theme through `programs.opencode.cli.theme.name` instead;
  # the upstream target keeps providing the `themes.stylix` palette file.
  # Remove this module once stylix's opencode target learns `cli`
  # (see TODO.md under Patches).
  programs.opencode = lib.mkIf (config.stylix.targets.opencode.enable or false) {
    tui = lib.mkForce {};
    cli.theme.name = "stylix";
  };
}
