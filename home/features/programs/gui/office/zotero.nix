{
  config,
  inputs,
  pkgs,
  system,
  ...
}: {
  programs.zotero = {
    enable = true;
    # INFO: zotero 10.0.2 does not build on nixpkgs unstable. It bundles Firefox
    # ESR as its `xulrunner` and greps `modules/ActorManagerParent.sys.mjs` for
    # translation metadata; the ESR 153.3.0 -> 153.4.0 bump (NixOS/nixpkgs#567873)
    # changed that file, so the build aborts with
    # `AboutTranslations: \{ and ^  }, not found ... -- aborting`.
    # See NixOS/nixpkgs#568692, which reproduces on Hydra against this rev.
    # 26.05's zotero 9.0.6 still works and comes from the binary cache.
    # Revert to `pkgs.zotero` once that issue is fixed (or once zotero 11 lands,
    # which already targets ESR 153).
    package = pkgs.stable.zotero;

    settings = {
      dataDir = "Documents/Zotero";
      sync.server.username = "<zotero-account-username>";
      betterBibTeX.autoPinInCitations = true;
      betterBibTeX.citekeyFormat = "[auth][year]";
    };

    profiles.${config.home.username} = {
      isDefault = true;

      extensions = with inputs.vortriz-nur.legacyPackages.${system}.zoteroAddons; [
        zotero-better-bibtex # Stable citation keys plus BibTeX/LaTeX export.
        zotero-scipdf # fetch full-text PDFs from Sci-Hub by DOI.
        zotmoov # move/rename attachments out of Zotero's opaque storage/ tree.
      ];
    };
  };

  # Browser extensions
  programs = {
    chromium.extensions = [{id = "ekhagklcjbdpajgpjgmbionohlpdbjgc";}];
    librewolf.profiles.default.extensions.packages = [pkgs.firefox-addons.zotero-connector];
  };
}
