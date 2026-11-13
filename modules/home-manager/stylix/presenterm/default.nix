{
  inputs,
  config,
  lib,
  ...
}: {
  options.stylix.targets.presenterm = {
    enable =
      lib.mkEnableOption "presenterm theming"
      // {
        default = config.programs.presenterm.enable;
        defaultText = lib.literalExpression "config.programs.presenterm.enable";
      };
  };

  config = lib.mkIf config.stylix.targets.presenterm.enable {
    programs.presenterm.themes.stylix = with config.lib.stylix.colors; let
      inherit (config.stylix) polarity;
    in {
      extends = polarity;

      default = {
        margin.percent = 8;
        colors = {
          foreground = base05;
          background = base00;
        };
      };

      slide_title = {
        prefix = "█";
        alignment = "left";
        padding_bottom = 1;
        colors.foreground = base08;
        bold = true;
        font_size = 2;
      };

      code = {
        alignment = "center";
        minimum_size = 50;
        minimum_margin.percent = 8;
        theme_name = "base16-stylix";
        padding = {
          horizontal = 2;
          vertical = 1;
        };
        background = false;
      };

      execution_output = {
        colors = {
          foreground = base05;
          background = base01;
        };
        status = {
          running.foreground = base0C;
          success.foreground = base0B;
          failure.foreground = base08;
          not_started.foreground = base09;
        };
      };

      inline_code.colors = {
        foreground = base0B;
        background = base02;
      };

      intro_slide = {
        title = {
          alignment = "center";
          colors.foreground = base0D;
          font_size = 2;
        };
        subtitle = {
          alignment = "center";
          colors.foreground = base0C;
        };
        author = {
          alignment = "center";
          colors.foreground = base06;
          positioning = "page_bottom";
        };
      };

      headings = {
        h1 = {
          prefix = "██";
          colors.foreground = base09;
        };
        h2 = {
          prefix = "▓▓▓";
          colors.foreground = base0B;
        };
        h3 = {
          prefix = "▒▒▒▒";
          colors.foreground = base0C;
        };
        h4 = {
          prefix = "░░░░░";
          colors.foreground = base0D;
        };
        h5 = {
          prefix = "░░░░░░";
          colors.foreground = base0E;
        };
        h6 = {
          prefix = "░░░░░░░";
          colors.foreground = base0F;
        };
      };

      block_quote = {
        prefix = "▍ ";
        colors = {
          foreground = base06;
          background = base01;
        };
      };

      alert = {
        prefix = "▍ ";
        base_colors = {
          foreground = base06;
          background = base01;
        };
        styles = {
          note.color = base0D;
          tip.color = base0B;
          important.color = base0E;
          warning.color = base09;
          caution.color = base08;
        };
      };

      typst.colors = {
        foreground = base06;
        background = base01;
      };

      footer = {
        style = "template";
        left = "{author}";
        center = "{event}";
        right = "{current_slide} / {total_slides}";
        colors.foreground = base04;
      };

      modals.selection_colors.foreground = base09;

      mermaid = {
        background = "transparent";
        theme = polarity;
      };

      d2.theme =
        if polarity == "dark"
        then 200
        else 100;

      layout_grid.color = base0D;
    };

    # INFO: Code highlight theme sourced from stylix's bat template
    xdg.configFile."presenterm/themes/highlighting/base16-stylix.tmTheme".source =
      config.lib.stylix.colors
      {
        template = builtins.readFile "${inputs.stylix}/modules/bat/base16-stylix.tmTheme.mustache";
        extension = ".tmTheme";
      };

    programs.presenterm.settings.defaults.theme = lib.mkDefault "stylix";
  };
}
