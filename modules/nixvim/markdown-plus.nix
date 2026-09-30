# INFO: markdown-plus.nvim — powerful Markdown toolkit (formatting, lists,
# headers/TOC, tables, links, images, callouts, footnotes, thematic breaks).

{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
{
  imports = [
    (lib.nixvim.plugins.mkNeovimPlugin {
      name = "markdown-plus";
      # The Lua module is `markdown-plus` (same as `name`).
      moduleName = "markdown-plus";
      # The package (overlay attr) is still `markdown-plus-nvim`.
      package = "markdown-plus-nvim";
      url = "https://github.com/YousefHadder/markdown-plus.nvim";
      maintainers = [ ];
      isColorscheme = false;

      description = ''
        A feature-rich Markdown toolkit for Neovim: text formatting, smart list
        editing, headers & TOC, table editing, links, images, callouts,
        footnotes and thematic breaks. Runs on markdown (and configured
        filetype) buffers.
      '';

      settingsOptions = {
        filetypes =
          defaultNullOpts.mkNullable (types.listOf types.str)
            [
              "markdown"
            ]
            ''
              Filetypes the plugin activates in. Defaults to `markdown`.
            '';

        features = {
          list_management = defaultNullOpts.mkBool true ''
            Enable smart list management.
          '';

          text_formatting = defaultNullOpts.mkBool true ''
            Enable text formatting toggles (bold, italic, ...).
          '';

          thematic_break = defaultNullOpts.mkBool true ''
            Enable thematic break insertion/cycling.
          '';

          links = defaultNullOpts.mkBool true ''
            Enable link manipulation.
          '';

          images = defaultNullOpts.mkBool true ''
            Enable image insertion/editing.
          '';

          headers_toc = defaultNullOpts.mkBool true ''
            Enable header manipulation and table of contents.
          '';

          quotes = defaultNullOpts.mkBool true ''
            Enable blockquote toggling.
          '';

          callouts = defaultNullOpts.mkBool true ''
            Enable GFM callout handling.
          '';

          code_block = defaultNullOpts.mkBool true ''
            Enable fenced code block handling.
          '';

          html_block_awareness = defaultNullOpts.mkBool true ''
            Make list/table editing aware of HTML blocks.
          '';

          table = defaultNullOpts.mkBool true ''
            Enable table editing.
          '';

          footnotes = defaultNullOpts.mkBool true ''
            Enable footnote handling.
          '';
        };

        keymaps = {
          enabled = defaultNullOpts.mkBool true ''
            Install the plugin's default buffer-local keymaps.
          '';
        };

        toc = {
          initial_depth = defaultNullOpts.mkInt 2 ''
            Minimum header depth included in generated TOCs.
          '';
        };

        table = {
          enabled = defaultNullOpts.mkBool true ''
            Enable the table module.
          '';

          auto_format = defaultNullOpts.mkBool true ''
            Auto-format tables as you type.
          '';

          default_alignment =
            defaultNullOpts.mkEnum
              [
                "left"
                "center"
                "right"
              ]
              "left"
              ''
                Default cell alignment.
              '';

          confirm_destructive = defaultNullOpts.mkBool true ''
            Ask for confirmation before destructive table actions.
          '';

          width_mode =
            defaultNullOpts.mkNullable
              (types.enum [
                "literal"
                "segment"
              ])
              "literal"
              ''
                Table width mode: account for CJK/harfbuzz segment widths.
              '';

          wrap_break = defaultNullOpts.mkStr "<br>" ''
            Line-break token used when wrapping/unwrapping cell content.
          '';

          max_column_width = defaultNullOpts.mkNullable types.int null ''
            Maximum column width before auto-wrapping cell content.
          '';

          auto_wrap = defaultNullOpts.mkBool false ''
            Automatically wrap cell content that exceeds `max_column_width`.
          '';

          cell_editor = {
            enabled = defaultNullOpts.mkBool true ''
              Enable the floating cell editor popup.
            '';

            border = defaultNullOpts.mkStr "rounded" ''
              Border style of the cell editor popup.
            '';

            width = defaultNullOpts.mkFloat 0.6 ''
              Width of the cell editor relative to the window (0..1).
            '';

            height = defaultNullOpts.mkFloat 0.4 ''
              Height of the cell editor relative to the window (0..1).
            '';
          };

          keymaps = {
            enabled = defaultNullOpts.mkBool true ''
              Install the plugin's default table keymaps.
            '';

            prefix = defaultNullOpts.mkStr "<localleader>t" ''
              Prefix for table keymaps.
            '';

            insert_mode_navigation = defaultNullOpts.mkBool false ''
              Map <A-hjkl> (or the flake's remapped <A-jklç>) for cell
              navigation in insert mode.
            '';
          };
        };

        callouts = {
          default_type = defaultNullOpts.mkStr "NOTE" ''
            Default callout type when inserting.
          '';

          custom_types = defaultNullOpts.mkNullable (types.listOf types.str) [ ] ''
            Additional custom callout types (uppercase words).
          '';
        };

        thematic_break = {
          style =
            defaultNullOpts.mkNullable
              (types.enum [
                "---"
                "***"
                "___"
              ])
              "---"
              ''
                Marker style used when inserting thematic breaks.
              '';
        };

        code_block = {
          enabled = defaultNullOpts.mkBool true ''
            Enable the code block module.
          '';

          fence_style =
            defaultNullOpts.mkNullable
              (types.enum [
                "backtick"
                "tilde"
              ])
              "backtick"
              ''
                Fence style for inserted code blocks.
              '';

          languages =
            defaultNullOpts.mkNullable (types.listOf types.str)
              [
                "lua"
                "python"
                "javascript"
                "typescript"
                "bash"
                "json"
                "yaml"
                "markdown"
              ]
              ''
                Language choices offered when inserting a fenced code block.
              '';
        };

        footnotes = {
          section_header = defaultNullOpts.mkStr "Footnotes" ''
            Header line used when inserting a footnotes section.
          '';

          confirm_delete = defaultNullOpts.mkBool true ''
            Ask for confirmation before deleting a footnote.
          '';
        };

        list = {
          smart_outdent = defaultNullOpts.mkBool true ''
            Smart outdent on <S-Tab>.
          '';

          whitespace =
            defaultNullOpts.mkNullable
              (types.enum [
                "single"
                "shiftwidth"
              ])
              "single"
              ''
                Whitespace strategy when adding list markers.
              '';

          whitespace_width = defaultNullOpts.mkInt 4 ''
            Number of spaces used when `whitespace = "single"`.
          '';

          checkbox_completion = {
            enabled = defaultNullOpts.mkBool false ''
              Auto-fill checkbox text on completion.
            '';

            format =
              defaultNullOpts.mkNullable
                (types.enum [
                  "emoji"
                  "comment"
                  "dataview"
                  "parenthetical"
                ])
                "emoji"
                ''
                  Rendering format for completed checkboxes.
                '';

            date_format = defaultNullOpts.mkStr "%Y-%m-%d" ''
              Date format used when completing checkboxes.
            '';

            remove_on_uncheck = defaultNullOpts.mkBool true ''
              Remove the completion text when unchecking.
            '';

            update_existing = defaultNullOpts.mkBool true ''
              Refresh the completion text of already-completed checkboxes.
            '';
          };
        };

        links = {
          smart_paste = {
            enabled = defaultNullOpts.mkBool false ''
              Auto-convert a pasted URL into a markdown link.
            '';

            timeout = defaultNullOpts.mkInt 5 ''
              Seconds to wait for clipboard content after `smart_paste`.
            '';
          };
        };
      };

      settingsExample = {
        filetypes = [ "markdown" ];
        features.table = true;
        table.default_alignment = "left";
      };
    })
  ];

  # INFO: Disabled by default, like every nixvim plugin. Enabling is independent
  # of any host program. The plugin's own keymaps stay enabled; the flake's
  # extra buffer-local bindings live in
  # `home/features/keymaps/*/nixvim/plugins/markdown-plus/`.
  plugins.markdown-plus.lazyLoad.enable = lib.mkDefault false;
}
