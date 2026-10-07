{ config, lib, pkgs, ... }:
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

    # INFO: Force-installed via the ExtensionSettings policy; see
    # modules/home-manager/librewolf-extensions.
    extensions = with pkgs.firefox-addons; [
      darkreader
      noscript
    ];
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
