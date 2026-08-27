{
  config,
  inputs,
  pkgs,
  system,
  ...
}:
let
  userJs = "${config.home.homeDirectory}/.zotero/zotero/${config.home.username}/user.js";
  zoteroAddons = inputs.vortriz-nur.legacyPackages.${system}.zoteroAddons;

  # INFO: Temporary hash override for zotero-better-bibtex 9.0.63
  # Upstream (Vortriz/nur-packages) shipped a stale hash for the .xpi
  # (specified: sha256-NKbXp..., got: sha256-Ok0IDsl...). The release was
  # re-uploaded, so the old hash no longer matches.
  # Remove this override once upstream publishes a fixed hash.
  better-bibtex = zoteroAddons.zotero-better-bibtex.overrideAttrs (old: {
    src = pkgs.fetchurl {
      url = "https://github.com/retorquere/zotero-better-bibtex/releases/download/v9.0.63/zotero-better-bibtex-9.0.63.xpi";
      hash = "sha256-Ok0IDslBU6jCS/gnVonF+UbZnjFLauD6tQYNaXD1Y4g=";
    };
  });
in
{

  programs.zotero = {
    enable = true;
    package = pkgs.zotero;

    profiles.${config.home.username} = {
      isDefault = true;

      extensions = [
        better-bibtex
        zoteroAddons.zotero-scipdf
        zoteroAddons.zotmoov
      ];
    };
  };

  sops = {
    secrets = {
      "zotero/username" = { };
      "zotero/apiKey" = { };
    };
    templates."zotero-user-js" = {
      mode = "0600";
      path = userJs;
      content =
        let
          username = config.sops.placeholder."zotero/username";
          apiKey = config.sops.placeholder."zotero/apiKey";
        in
        # js
        ''
          user_pref("extensions.zotero.sync.server.username", "${username}");
          user_pref("extensions.zotero.sync.server.apiKey", "${apiKey}");
          user_pref("extensions.zotero.betterBibTeX.autoPinInCitations", true);
          user_pref("extensions.zotero.betterBibTeX.citekeyFormat", "[auth][year]");
          user_pref("extensions.zotero.dataDir", "${config.xdg.userDirs.documents}/Zotero");
          user_pref("extensions.zotero.firstRun2", false);
          user_pref("extensions.zotero.useDataDir", true);
        '';
    };
  };

  # Browser extensions
  programs = {
    chromium.extensions = [ { id = "ekhagklcjbdpajgpjgmbionohlpdbjgc"; } ];
    librewolf.profiles.default.extensions.packages = [ pkgs.firefox-addons.zotero-connector ];
  };
}
