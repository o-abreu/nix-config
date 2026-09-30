{
  programs.nixvim.plugins.crazy-coverage = {
    enable = true;
    # INFO: `auto_reload` was not a valid crazy-coverage key (the plugin warned
    # about it). It auto-watches and reloads coverage files once loaded; this
    # enables auto-loading of coverage when a file is opened.
    settings.auto_load = true;
    lazyLoad.settings.cmd =
      [
        "Toggle"
        "ToggleHitCount"
        "ToggleSignColumn"
        "ToggleBranchOverlay"
        "ToggleRegionOverlay"
        "ToggleNvimTree"
        "ToggleNeoTree"
        "Load"
        "Summary"
        "NextCovered"
        "PrevCovered"
        "NextUncovered"
        "PrevUncovered"
        "NextPartial"
        "PrevPartial"
      ]
      |> map (m: "Coverage" + m);
  };
}
