{ config, lib, pkgs, ... }:
let
  inherit (pkgs.firefox-addons) darkreader;
in
{
  programs.librewolf = {
    enable = true;
    languagePacks = [
      "en-US"
      "pt-BR"
    ];
    profiles.default = {
      id = 0;
      isDefault = true;
      settings = {
        "extensions.autoDisableScopes" = 0;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.translations.neverTranslateLanguages" = "pt";
        "privacy.resistFingerprinting.letterboxing" = true;
      };
    };
  };

  # INFO: Darkreader needs the `<all_urls>` permission to inject its theme on
  # every website. Sideloading via `extensions.packages` does not grant those
  # install-time permissions, so install it through the enterprise
  # ExtensionSettings policy instead, which auto-grants them and auto-enables
  # the addon (same approach as the Firenvim extension).
  programs.librewolf.policies.ExtensionSettings.${darkreader.addonId} = {
    installation_mode = "force_installed";
    install_url = "file://${darkreader.src}";
  };

  home.sessionVariables.BROWSER = "${lib.getExe config.programs.librewolf.package}";
  xdg.mimeApps.defaultApplications = lib.genAttrs [
    "text/html"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/chrome"
    "application/x-extension-htm"
    "application/x-extension-html"
    "application/x-extension-shtml"
    "application/xhtml+xml"
    "application/x-extension-xhtml"
    "application/x-extension-xht"
  ] (_: "librewolf.desktop");
}
