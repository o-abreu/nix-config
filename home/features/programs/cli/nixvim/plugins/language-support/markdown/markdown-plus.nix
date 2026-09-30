{ lib, config, ... }: {
  _module.args.markdownPlus =
    let
      inherit (config.programs.nixvim.plugins) markdown-plus;
    in
    {
      inherit (markdown-plus) enable;
      prefix = "<localleader>";
      # INFO: The setting is a `defaultNullOpts` option, so it is `null` unless
      # explicitly set (null means "use the plugin default"). Fall back to the
      # plugin's documented default so `tablePrefix + "x"` never coerces null.
      tablePrefix =
        if markdown-plus.settings.table.keymaps.prefix == null then
          "<localleader>t"
        else
          markdown-plus.settings.table.keymaps.prefix;

      bind =
        {
          key,
          plug,
          mode ? "n",
          desc,
        }:
        {
          inherit key mode;
          action = "<Plug>(MarkdownPlus${plug})";
          options = {
            buffer = true;
            silent = true;
            inherit desc;
          };
        };

      localGroup =
        let
          lua = config.lib.nixvim.lua;
        in
        key: group: icon:
        lib.mkIf config.programs.nixvim.plugins.which-key.enable
          # lua
          ''require("which-key").add(${
            lua.toLuaObject {
              __unkeyed-1 = key;
              inherit group icon;
              buffer = true;
            }
          })'';
    };

  programs.nixvim.plugins.markdown-plus.enable = true;
}
