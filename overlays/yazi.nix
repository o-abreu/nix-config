# INFO: Modifications to pkgs related to Yazi. Yazi is set to unstable as many plugins require version 26.8.15 to work.
final: prev: {
  yaziPlugins =
    prev.yaziPlugins
    // {
      smart-switch = final.callPackage ../pkgs/smart-switch {};
      smart-tab = final.callPackage ../pkgs/smart-tab {};
    };
}
