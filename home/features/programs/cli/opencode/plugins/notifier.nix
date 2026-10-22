{pkgs, ...}: {
  programs.opencode = {
    settings.plugin = ["@mohak34/opencode-notifier@latest"];
    extraPackages = [pkgs.libnotify];
  };
}
