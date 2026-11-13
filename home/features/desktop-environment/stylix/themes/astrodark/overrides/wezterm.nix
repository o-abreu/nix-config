{config, ...}: {
  stylix.targets.wezterm.enable = false;

  programs.wezterm.extraConfig."colorscheme" = with config.lib.stylix.colors;
  # lua
    ''
      local wezterm = require("wezterm")
      local module = {}

      function module.apply_to_config(config)
        -- Modify the Ayu Mirage default theme
        local theme = "Ayu Mirage"
        local custom = wezterm.color.get_builtin_schemes()[theme]
        custom.background = "${base00}"
        custom.cursor_bg = "${base07}"
        custom.tab_bar = {
        background = "${base01}",
          new_tab = {
            bg_color = "${base01}",
            fg_color = "${base07}",
          },
        }
        custom.cursor_border = custom.cursor_bg
        config.color_schemes = { [theme] = custom }
        config.color_scheme = theme
      end

      return module
    '';
}
