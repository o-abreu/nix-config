{
  cfg,
  lib,
  pkgs,
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

  # INFO: A list element is keyed by its own `name` attribute, so a catalog entry
  # can be passed straight through — `plugins = with pkgs.weztermPlugins; [
  # tabline-wez ];` — without restating the name. A bare string is accepted as a
  # shorthand for the same catalog lookup. The attribute-set form keeps the key
  # explicit, for sources outside the catalog or for registering a plugin under
  # a different require() name.
  #
  # Both consumers below go through `pluginName`, so a malformed entry produces
  # the readable message rather than a bare `attribute 'name' missing`.
  pluginName =
    entry:
    if isString entry then
      assert lib.assertMsg
        (pkgs.weztermPlugins ? ${entry})
        "programs.wezterm.plugins: no entry '${entry}' in pkgs.weztermPlugins (known: ${concatStringsSep ", " (builtins.attrNames pkgs.weztermPlugins)})";
      entry
    else
      assert lib.assertMsg
        (entry ? name)
        "programs.wezterm.plugins: a list entry needs a `name` attribute to be keyed by (${builtins.toJSON entry})";
      entry.name;

  fromList = entry: nameValuePair (pluginName entry) (if isString entry then pkgs.weztermPlugins.${entry} else entry);

  allPlugins =
    if isList cfg.plugins then
      map fromList cfg.plugins |> listToAttrs
    else
      cfg.plugins;

  # INFO: Two modules listing the same plugin concatenate into one list, and
  # `listToAttrs` would keep the last entry silently. Report it instead. Not a
  # concern for the attribute-set form: Nix dedupes keys by construction.
  duplicateNames =
    if isList cfg.plugins then
      let
        names = map pluginName cfg.plugins;
      in
      filter (name: 1 < length (filter (n: n == name) names)) (unique names)
    else
      [ ];

  registeredPlugins = allPlugins |> mapAttrs (_: registeredPlugin) |> filterAttrs (_: r: r != null);

  plainPlugins = filterAttrs (_: v: registeredPlugin v == null) allPlugins;

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
  inherit plainPlugins pluginListShim registeredPlugins duplicateNames;
}
