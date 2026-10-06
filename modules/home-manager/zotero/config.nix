{
  config,
  lib,
  ...
}: let
  inherit (config.programs) zotero;

  # INFO: Zotero's Linux profile layout, matching the vortriz-nur module
  #       (`profilesPath = ".zotero/zotero"`).
  profilesPath = ".zotero/zotero";
  defaultProfileName = lib.head (
    lib.attrNames (lib.filterAttrs (_: profile: profile.isDefault) zotero.profiles)
  );

  # INFO: Flatten the nested `settings` tree into Zotero's flat
  #       `extensions.zotero.<dotted.path>` preference names.
  flatten = prefix: attrs:
    lib.concatMapAttrs (
      name: value: let
        key =
          if prefix == ""
          then name
          else "${prefix}.${name}";
      in
        if lib.isAttrs value
        then flatten key value
        else {${key} = value;}
    )
    attrs;

  # INFO: `settings.dataDir` is relative to $HOME for the preservation module,
  #       but the preference needs an absolute path, and Zotero only honours it
  #       together with `useDataDir`
  #       (chrome/content/zotero/xpcom/dataDirectory.js).
  dataDir = zotero.settings.dataDir or null;
  dataDirPrefs = lib.optionalAttrs (dataDir != null) {
    dataDir = "${config.home.homeDirectory}/${dataDir}";
    useDataDir = true;
  };

  # INFO: A user who configured anything has already been through the first-run
  #       flow as far as this configuration is concerned, so skip the wizard
  #       (`zoteroPane.js` flips `firstRun2` to false after it runs once).
  firstRunPrefs = lib.optionalAttrs (zotero.settings != {}) {
    firstRun2 = false;
  };

  managedPrefs = flatten "extensions.zotero" (zotero.settings // dataDirPrefs // firstRunPrefs);

  # INFO: Zotero prefs are only bool/int/string. Structured values are stored as
  #       JSON *strings* (the default `extensions.zotero.findPDFs.resolvers` is
  #       `'[]'`), so lists and attrsets are double-encoded.
  renderValue = value:
    if lib.isBool value || lib.isInt value || lib.isString value
    then builtins.toJSON value
    else if lib.isList value || lib.isAttrs value
    then builtins.toJSON (builtins.toJSON value)
    else throw "programs.zotero.settings: unsupported value of type '${builtins.typeOf value}'";
in {
  config = lib.mkIf (zotero.enable && zotero.profiles != {}) {
    home.file = lib.mkIf (managedPrefs != {}) {
      "${profilesPath}/${zotero.profiles.${defaultProfileName}.path}/user.js" = {
        text =
          managedPrefs
          |> lib.mapAttrsToList (name: value: ''user_pref("${name}", ${renderValue value});'')
          |> lib.concatStringsSep "\n";
      };
    };
  };
}
