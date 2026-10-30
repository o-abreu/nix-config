{
  config,
  lib,
  snacksTerminal,
  ...
}: let
  inherit (snacksTerminal) toggleTerm;
  prefix = "<leader>t";
  replPrefix = "<localleader>R";
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
  # INFO: Keybind-only terminal conventions. The factory (`snacksTerminal`) is
  # shared with the non-keymap integrations under `programs/`, so the prefixes
  # are exposed separately. `allLayouts`, `shellTerminals` and `defaultTerm`
  # stay local: they are only consumed by this file and by `vim-slime`, which
  # imports `_layouts.nix` directly.
  _module.args.snacksTerminalKeys = {
    inherit (snacksTerminal) enable;
    inherit prefix replPrefix;
  };

  programs.nixvim = {
    plugins.which-key.settings.spec = lib.mkIf snacksTerminal.enable [
      {
        __unkeyed-1 = prefix;
        group = "Terminal";
        icon = "";
      }
    ];

    keymaps = with config.programs;
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
      ++ lib.optional btop.enable {
        key = prefix + "b";
        action = toggleTerm {
          cmd = lib.getExe btop.package;
          opts.count = 2;
        };
        mode = "n";
        options.desc = "Btop";
      }
      ++ lib.optional lazygit.enable {
        key = prefix + "l";
        action = toggleTerm {
          cmd = lib.getExe lazygit.package;
          opts.count = 1;
        };
        mode = "n";
        options.desc = "Lazygit";
      }
      ++ shellTerminals
      |> lib.map (m: m // {mode = m.mode or "n";});
  };
}
