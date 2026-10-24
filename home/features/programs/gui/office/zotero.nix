{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}: {
  # INFO: Scoped license releases for Zotero 10's revived Firefox ESR 140
  # XULrunner (`firefox-esr-140-bin`, NixOS/nixpkgs#572466). The prebuilt
  # binary is flagged `unfree` because Mozilla's Firefox Terms of Use carry
  # usage restrictions (nixpkgs declares them as the "Firefox Terms of Use"
  # license, free = false) and `insecure` because ESR 140 reached end-of-life
  # on 2026-10-13 — it is embedded solely as Zotero's xulrunner, never a
  # browser. `allowUnfreePackages` composes *additively* with the nixvim
  # `allowUnfreePredicate` (both are checked; see check-meta.nix's unfree
  # logic), and `allowInsecurePredicate` is keyed on the pname so it survives
  # ESR security bumps (140.17.0esr -> newer), unlike
  # `permittedInsecurePackages`, which match the full name+version.
  nixpkgs.config = {
    allowUnfreePackages = ["firefox-esr-140-bin-unwrapped"];
    allowInsecurePredicate = pkg: lib.getName pkg == "firefox-esr-140-bin-unwrapped";
  };

  programs.zotero = {
    enable = true;

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
