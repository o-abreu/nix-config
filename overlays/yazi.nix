# INFO: Modifications to pkgs related to Yazi. Yazi is set to unstable as many plugins require version 26.8.15 to work.
final: prev: {
  yaziPlugins =
    prev.yaziPlugins
    // {
      smart-switch = final.callPackage ../pkgs/smart-switch {};
      smart-tab = final.callPackage ../pkgs/smart-tab {};
      # INFO: office.yazi (nixpkgs rev 2025-09-20) calls the removed
      # `ya.preview_widgets()` API; rename it to `ya.preview_widget()` for
      # Yazi >= 26.8.15. Upstream: macydnah/office.yazi#23.
      office = prev.yaziPlugins.office.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          substituteInPlace main.lua \
            --replace-fail 'ya.preview_widgets(job, {})' 'ya.preview_widget(job, {})'
        '';
      });
    };
}
