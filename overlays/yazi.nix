# INFO: Modifications to pkgs related to Yazi. Yazi is set to unstable as many plugins require version 26.8.15 to work.
final: prev:
let
  yaziVersion = prev.yazi.version or "0";
  needsUnstable = builtins.compareVersions yaziVersion "26.8.15" < 0;
  # When yazi itself comes from unstable, take its plugin set from unstable too.
  # The stable `toggle-pane` still reads the deprecated `rt.mgr.ratio.parent`
  # table API; the unstable build uses the current `ratio[1..3]` array API.
  yaziPlugins = if needsUnstable then final.unstable.yaziPlugins else prev.yaziPlugins;
in
{
  yazi = if needsUnstable then final.unstable.yazi else prev.yazi;
  yaziPlugins = yaziPlugins // {
    smart-switch = final.callPackage ../pkgs/smart-switch { };
    smart-tab = final.callPackage ../pkgs/smart-tab { };
  };
}
