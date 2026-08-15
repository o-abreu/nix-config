{ pkgs, ... }:
{
  programs.yazi = {
    plugins.gvfs = pkgs.yaziPlugins.gvfs;
    yaziPlugins.require.gvfs = { };
    settings.plugin.prepend_previewers = [
      {
        url = "/run/user/1000/gvfs/**/*";
        run = "noop";
      }
    ];
  };
}
