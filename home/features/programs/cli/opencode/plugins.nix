{ pkgs, ... }: {
  programs.opencode.settings.plugin = [
    "@mohak34/opencode-notifier@latest"
    "@zenobius/opencode-skillful"
  ];
  home.packages = [
    # notify-send for desktop notifications (opencode-notifier)
    pkgs.libnotify
  ];
}
