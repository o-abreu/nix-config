{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
{
  programs.yazi = lib.mkIf osConfig.services.gvfs.enable {
    plugins.gvfs = pkgs.yaziPlugins.gvfs;
    yaziPlugins.require.gvfs = { };
    settings.plugin.prepend_previewers =
      let
        uid = osConfig.users.users.${config.home.username}.uid;
      in
      [
        {
          url = "/run/user/${toString uid}/gvfs/**/*";
          run = "noop";
        }
      ];
  };
}
