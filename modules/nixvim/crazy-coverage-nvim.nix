# INFO: crazy-coverage.nvim — display code coverage overlays in Neovim.

{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
{
  imports = [
    (lib.nixvim.plugins.mkNeovimPlugin {
      name = "crazy-coverage";
      # The Lua module is `crazy-coverage`, not `crazy-coverage`.
      moduleName = "crazy-coverage";
      package = "crazy-coverage-nvim";
      url = "github:mr-u0b0dy/crazy-coverage.nvim";
      maintainers = [ ];

      description = ''
        Display code coverage overlays directly in Neovim with smart auto-loading
        and file watching. Supports LCOV, LLVM JSON, Cobertura XML, Go
        Coverprofile, GCOV, LLVM Profdata, and Tarpaulin JSON formats.
      '';

      settingsOptions = {
        # Display
        virt_text_pos = defaultNullOpts.mkStr "eol" ''
          Position of virtual text overlays. Options: `"eol"`, `"right_align"`, `"inline"`.
        '';

        default_show_hit_count = defaultNullOpts.mkBool true ''
          Show hit counts by default when coverage is loaded.
        '';

        show_hit_count = defaultNullOpts.mkBool true ''
          Whether hit count display is enabled.
        '';

        show_percentage = defaultNullOpts.mkBool false ''
          Show percentage instead of raw hit counts.
        '';

        enable_line_hl = defaultNullOpts.mkBool true ''
          Enable line highlighting for covered/uncovered lines.
        '';

        auto_adapt_colors = defaultNullOpts.mkBool true ''
          Automatically adapt highlight colors to the current colorscheme.
        '';

        # Colors
        colors = {
          covered = defaultNullOpts.mkNullable (types.nullOr types.str) null ''
            Override color for covered lines. When `null`, uses highlight group.
          '';

          uncovered = defaultNullOpts.mkNullable (types.nullOr types.str) null ''
            Override color for uncovered lines. When `null`, uses highlight group.
          '';

          partial = defaultNullOpts.mkNullable (types.nullOr types.str) null ''
            Override color for partially covered lines. When `null`, uses highlight group.
          '';
        };

        covered_hl = defaultNullOpts.mkStr "CoverageCovered" ''
          Highlight group for covered lines.
        '';

        uncovered_hl = defaultNullOpts.mkStr "CoverageUncovered" ''
          Highlight group for uncovered lines.
        '';

        partial_hl = defaultNullOpts.mkStr "CoveragePartial" ''
          Highlight group for partially covered lines.
        '';

        # File detection
        coverage_dirs =
          defaultNullOpts.mkNullable (types.listOf types.str)
            [
              "build/coverage"
              "coverage"
              "build"
              "."
            ]
            ''
              Directories to search for coverage files, relative to the project root.
            '';

        project_markers =
          defaultNullOpts.mkNullable (types.listOf types.str)
            [
              ".git"
              "CMakeLists.txt"
              "Makefile"
              "compile_commands.json"
            ]
            ''
              Markers used to find the project root directory.
            '';

        # Cache
        auto_load = defaultNullOpts.mkBool false ''
          Automatically load coverage when toggling.
        '';

        cache_enabled = defaultNullOpts.mkBool true ''
          Enable caching of parsed coverage data.
        '';
      };

      settingsExample = {
        virt_text_pos = "eol";
        default_show_hit_count = true;
        enable_line_hl = true;
        auto_adapt_colors = true;
        coverage_dirs = [
          "build/coverage"
          "coverage"
          "."
        ];
      };
    })
  ];

  # INFO: Disabled by default, like every nixvim plugin. Enabling is independent
  # of any host program; consumers opt in with
  # `programs.nixvim.plugins.crazy-coverage.enable`.
  plugins.crazy-coverage.lazyLoad.enable = lib.mkDefault false;
}
