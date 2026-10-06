{
  lib,
  ...
}:
with lib;
{
  # INFO: Extends the vortriz-nur `programs.zotero` module with a single
  #       free-form `settings` tree. It mirrors Zotero's
  #       `extensions.zotero.*` preference namespace as nested attrsets and is
  #       flattened into `user.js` by config.nix. See
  #       https://github.com/zotero/zotero/blob/main/defaults/preferences/zotero.js
  #       for the available preferences.
  #
  #       `settings.dataDir` is special-cased: it is interpreted relative to
  #       $HOME (so the NixOS preservation module can use it verbatim) and
  #       config.nix derives the absolute `dataDir` and `useDataDir`
  #       preferences from it.
  options.programs.zotero.settings = mkOption {
    type = types.attrsOf types.anything;
    default = { };
    example = literalExpression ''
      {
        dataDir = "Documents/Zotero";
        sync = {
          autoSync = true;
          server.username = "user@example.com";
        };
        betterBibTeX.autoPinInCitations = true;
        reader.darkTheme = "dark";
      }
    '';
    description = ''
      Zotero preferences, nested to mirror the `extensions.zotero.*` tree:
      `sync.server.username` becomes
      `extensions.zotero.sync.server.username`. Leaves may be booleans,
      integers, or strings; lists and attrsets are JSON-encoded, which is how
      Zotero stores structured preferences.

      {option}`programs.zotero.settings.dataDir` is relative to
      {file}`$HOME`.
    '';
  };
}
