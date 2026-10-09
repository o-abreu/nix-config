{
  config,
  lib,
  ...
}: let
  dataDir = "${config.home.homeDirectory}/${
    config.programs.zotero.settings.dataDir or "Zotero"
  }";
in {
  programs.nixvim = lib.mkIf config.programs.zotero.enable {
    plugins.snacks-zotero = {
      enable = true;
      settings = {
        zotero_db_path = "${dataDir}/zotero.sqlite";
        better_bibtex_db_path = "${dataDir}/better-bibtex.sqlite";
        zotero_storage_path = "${dataDir}/storage";
      };
    };
  };
}
