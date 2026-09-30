{
  cfg,
  lib,
}:
with lib;
let
  # INFO: WezTerm's plugin manager encodes repo URLs into directory names
  # (see wezterm's config-registry encoding). Reproduced here so plugins
  # installed via the generated shim resolve like official clones.
  encodePluginUrl =
    url: replaceStrings [ ":" "/" "\\" "." "%" ] [ "sCs" "sZs" "sBs" "sDs" "sPs" ] url;

  # Classify each plugin: explicit { url, src } values (e.g. the catalog
  # exposed at pkgs.weztermPlugins.<name>) register; everything else (paths,
  # bare inputs without a url) stays plain.
  registeredPlugin =
    v:
    if isAttrs v && v ? url && v ? src then
      {
        inherit (v) url src;
        dir = encodePluginUrl v.url;
      }
    else
      null;

  registeredPlugins = cfg.plugins |> mapAttrs (_: registeredPlugin) |> filterAttrs (_: r: r != null);

  plainPlugins = filterAttrs (_: v: registeredPlugin v == null) cfg.plugins;

  # INFO: Lua shim making require()-loaded plugins visible to
  # wezterm.plugin.list(), for plugins that assume installation via
  # wezterm's built-in plugin manager.
  pluginListShim =
    registeredPlugins
    |> mapAttrsToList (
      _: p:
      "{ plugin = '${p.url}', plugin_dir = wezterm.config_dir .. '/plugins/${p.dir}', component = '${p.dir}' },"
    )
    |> concatStringsSep "\n"
    |> (
      entries:
      optionalString (entries != "") ''
        local __real_plugin_list = wezterm.plugin.list
        wezterm.plugin.list = function()
          local plugins = __real_plugin_list()
          for _, entry in ipairs({
            ${entries}
          }) do
            plugins[#plugins + 1] = entry
          end
          return plugins
        end
      ''
    );
in
{
  inherit plainPlugins pluginListShim registeredPlugins;
}
