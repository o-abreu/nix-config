{
  config,
  lib,
  options,
  ...
}:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim.keymaps =
      let
        cfg = config.programs.nixvim.plugins.snacks;
        enable = cfg.enable && ((cfg.settings.picker.enabled or false) == true);
        toggle = func: { __raw = "function() Snacks.toggle.${func}():toggle() end"; };
        toggleOpt = name: opt: {
          __raw =
            # lua
            "function() Snacks.toggle.option('${opt}', { name = '${name}' }):toggle() end";
        };
        prefix = "<leader>u";
      in
      [
        {
          key = prefix + "d";
          action = toggle "diagnostics";
          options.desc = "Toggle Diagnostics";
        }
        {
          key = prefix + "s";
          action = toggleOpt "Spelling" "spell";
          options.desc = "Toggle Spellcheck";
        }
        {
          key = prefix + "w";
          action = toggleOpt "Wrap" "wrap";
          options.desc = "Toggle Word Wrap";
        }
        {
          key = prefix + "l";
          action = toggle "line_number";
          options.desc = "Toggle Line Numbers";
        }
        {
          key = prefix + "L";
          action = toggleOpt "Relative Number" "relativenumber";
          options.desc = "Toggle Relative Lines";
        }
        {
          key = prefix + "h";
          action = toggle "inlay_hints";
          options.desc = "Toggle Inlay Hints";
        }
        {
          key = prefix + "i";
          action = toggle "indent";
          options.desc = "Toggle Indent Guides";
        }
        {
          key = prefix + "t";
          action = toggle "treesitter";
          options.desc = "Toggle Treesitter";
        }
        {
          key = prefix + "W"; # Re-mapping your custom whitespace to W capital
          options.desc = "Toggle Whitespace Characters";
          action.__raw =
            # lua
            ''
              function()
                ${builtins.readFile ./whitespace/init.lua}
              end
            '';
        }
        {
          action.__raw =
            # lua
            ''
              function()
                ${builtins.readFile ./fold/init.lua}
              end
            '';
          key = prefix + "o";
          options.desc = "Toggle Fold Column";
        }
      ]
      |> map (m: m // { mode = "n"; })
      |> lib.optionals enable;
  };
}
