# INFO: Modifications to pkgs related to Yazi. Yazi is set to unstable as many plugins require version 26.8.15 to work.
final: prev:
let
  yaziVersion = prev.yazi.version or "0";
  needsUnstable = builtins.compareVersions yaziVersion "26.8.15" < 0;
in
{
  yazi = if needsUnstable then final.unstable.yazi else prev.yazi;
  yaziPlugins = prev.yaziPlugins // {
    smart-switch = final.callPackage ../pkgs/smart-switch { };
    smart-tab = final.callPackage ../pkgs/smart-tab { };
    max-preview = final.callPackage ../pkgs/max-preview { inherit (prev) yaziPlugins; };
  };
}
