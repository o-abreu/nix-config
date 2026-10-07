{
  config,
  lib,
  ...
}: let
  inherit (config.programs.nixvim.plugins) snacks;
  enable = snacks.enable && (snacks.settings.terminal.enabled or false);

  prefix = "<leader>t";

  toggleTerm = import ./_toggle-term.nix {inherit config lib;};
  allLayouts = import ./_layouts.nix {inherit lib toggleTerm;};

  defaultTerm = toggleTerm {
    opts = {
      count = 3;
      win.position = "float";
    };
  };

  shellTerminals = allLayouts {
    inherit prefix;
    count = 3;
  };
in {
  # INFO: Share the terminal factories with the integration modules under
  # `integrations/`. They cannot receive arguments directly, so expose them as
  # module args instead of duplicating the toggle/layout logic in every file.
  _module.args.snacksTerminal = {
    inherit enable prefix toggleTerm allLayouts shellTerminals;
    replPrefix = "<localleader>R";
  };

  programs.nixvim = {
    plugins.which-key.settings.spec = lib.mkIf enable [
      {
        __unkeyed-1 = prefix;
        group = "Terminal";
        icon = "";
      }
    ];

    keymaps =
      [
        {
          key = "<C-t>";
          action.__raw =
            # lua
            ''
              function()
                if _G.__last_term then
                  _G.__last_term()
                else
                  (${defaultTerm.__raw})()
                end
              end
            '';
          mode = ["n" "i" "t"];
          options.desc = "Toggle last terminal";
        }
      ]
      ++ shellTerminals
      |> lib.map (m: m // {mode = m.mode or "n";});
  };
}
