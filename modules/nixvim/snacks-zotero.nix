# INFO: snacks-zotero.nvim — pick Zotero citations with the snacks picker and
# append the picked entries to the project bibliography.
{lib, ...}: let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in {
  imports = [
    (lib.nixvim.plugins.mkNeovimPlugin {
      name = "snacks-zotero";
      # The Lua module is `snacks_zotero` (setup target).
      moduleName = "snacks_zotero";
      # The package (overlay attr) is `snacks-zotero-nvim`.
      package = "snacks-zotero-nvim";
      url = "https://github.com/Chiarandini/snacks-zotero.nvim";
      maintainers = [];

      description = ''
        A [snacks.nvim](https://github.com/folke/snacks.nvim) picker for Zotero
        citations. Picking an entry inserts the citation at the cursor and
        appends the BibTeX entry to the project bibliography, so the `.bib`
        stays self-contained and shareable. Reads the local Zotero SQLite
        database (Better BibTeX, or Zotero 8+ native citation keys).
      '';

      settingsOptions = {
        zotero_db_path = defaultNullOpts.mkStr "~/Zotero/zotero.sqlite" ''
          Path to Zotero's `zotero.sqlite` database.
        '';

        better_bibtex_db_path = defaultNullOpts.mkStr "~/Zotero/better-bibtex.sqlite" ''
          Path to Better BibTeX's `better-bibtex.sqlite`. Optional on Zotero 8+,
          where citation keys live natively in `zotero.sqlite`.
        '';

        zotero_storage_path = defaultNullOpts.mkStr "~/Zotero/storage" ''
          Zotero `storage/` directory, used to resolve stored PDF attachments.
        '';

        pdf_opener = defaultNullOpts.mkNullable (types.nullOr types.str) null ''
          Program used to open PDF attachments. When `null`, the platform default
          (`xdg-open`/`open`/`start`) is used.
        '';

        collection = defaultNullOpts.mkNullable (types.nullOr types.str) null ''
          Scope the picker to a single Zotero collection name.
        '';

        validate_bib_entry = defaultNullOpts.mkBool false ''
          Refuse to append entries that fail a syntactic BibTeX check.
        '';

        picker = {
          with_icons = defaultNullOpts.mkBool true ''
            Show NerdFont icons in the picker.
          '';

          hlgroups = {
            icons = defaultNullOpts.mkStr "SpecialChar" ''
              Highlight group for the icon column.
            '';

            author_year = defaultNullOpts.mkStr "Comment" ''
              Highlight group for the author/year column.
            '';

            title = defaultNullOpts.mkStr "Title" ''
              Highlight group for the title column.
            '';
          };
        };

        # INFO: `ft` (per-filetype `insert_key_formatter`/`locate_bib`) is left
        # to the open `settings` freeform; the plugin ships sensible defaults for
        # quarto, tex, asciidoc, typst and org.
      };

      settingsExample = {
        zotero_db_path = "~/Zotero/zotero.sqlite";
        zotero_storage_path = "~/Zotero/storage";
        collection = "phd-thesis";
      };
    })
  ];

  # INFO: The plugin registers `:SnacksZotero`/`<Plug>(snacks-zotero-picker)`
  # from `plugin/`, and `setup()` must run, so keep it eager.
  plugins.snacks-zotero.lazyLoad.enable = lib.mkDefault false;
}
