{config, ...}: {
  programs.wezterm.extraConfig."appearance" = with config.stylix.fonts;
  # lua
    ''
      local wezterm = require("wezterm")
      local module = {}

      function module.apply_to_config(config)

          -- Font settings
          config.warn_about_missing_glyphs = false
          config.font = wezterm.font_with_fallback {
            "${monospace.name}",
            "${emoji.name}",
          }
          config.font_size = ${toString sizes.terminal}
          config.line_height = 1.2

          -- Windows and tabs
          config.window_decorations = "NONE"
          config.tab_bar_at_bottom = true
          config.use_fancy_tab_bar = false
          config.hide_tab_bar_if_only_one_tab = false
        end

      return module
    '';
}
