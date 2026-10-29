{config, ...}: {
  programs.nixvim.plugins.bufferline.settings.options.groups.items = with config.lib.stylix.colors.withHashtag; [
    {
      name = "Tests";
      highlight = {
        underline = true;
        fg = base0B;
        sp = base03;
      };
      priority = 2;
      matcher.__raw =
        # lua
        ''
          function(buf)
            return buf.name:match('%test') or buf.name:match('%.spec')
          end
        '';
    }

    {
      name = "Docs";
      highlight = {
        underline = true;
        fg = base07;
        sp = base03;
      };
      auto_close = false;
      matcher.__raw =
        # lua
        ''
          function(buf)
            return buf.name:match('%.md') or buf.name:match('%.txt')
          end
        '';
    }

    {
      name = "AI";
      highlight = {
        underline = true;
        fg = base0F;
        sp = base03;
      };
      matcher.__raw =
        # lua
        ''
          function(buf)
            return buf.name:match('^term://Opencode')
          end
        '';
    }
  ];
}
