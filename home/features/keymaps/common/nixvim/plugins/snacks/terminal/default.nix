{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib) mkIf optional optionalAttrs;
in
{
  config = optionalAttrs (options ? programs.nixvim) {
    programs.nixvim =
      let
        cfg = config.programs.nixvim.plugins.snacks;
        enable = cfg.enable && (cfg.settings.terminal.enabled or false);
        prefix = {
          term = "<leader>t";
          repl = "<leader>Rs";
        };
      in
      {
        plugins = {
          which-key.settings.spec = mkIf enable [
            {
              __unkeyed-1 = prefix.term;
              group = "Terminal";
              icon = " ";
            }
            {
              __unkeyed-1 = prefix.repl;
              group = "Session";
              icon = " ";
            }
            {
              __unkeyed-1 = prefix.repl + "p";
              group = "Python";
              icon = "󰌠";
            }
            {
              __unkeyed-1 = prefix.repl + "i";
              group = "IPython";
              icon = "";
            }
            {
              __unkeyed-1 = prefix.repl + "j";
              group = "Julia";
              icon = "";
            }
            {
              __unkeyed-1 = prefix.repl + "r";
              group = "R";
              icon = "󰟔";
            }
          ];

          # Override keybinds from the pickers interfaces
          snacks.settings.picker =
            let
              clear = builtins.attrValues prefix |> lib.flip lib.genAttrs (_: false);
              override = {
                input.keys = clear;
                list.keys = clear;
              };
            in
            {
              win = mkIf enable override;
              sources.explorer.win = mkIf enable override;
            };
        };
        keymaps =
          let
            inherit (config.programs) lazygit btop;
            toggleTerm = import ./_toggle-term.nix { inherit config lib; };
            defaultTerm = toggleTerm {
              opts = {
                count = 3;
                win.position = "float";
              };
            };
            allLayouts =
              {
                prefix,
                count,
                cmd ? null,
              }:
              [
                {
                  key = "f";
                  position = "float";
                  desc = "Floating terminal";
                }
                {
                  key = "v";
                  position = "right";
                  desc = "Vertical split terminal";
                }
                {
                  key = "h";
                  position = "bottom";
                  desc = "Horizontal split terminal";
                }
              ]
              |> lib.map (layout: {
                key = prefix + layout.key;
                action = toggleTerm {
                  inherit cmd;
                  opts = {
                    inherit count;
                    win.position = layout.position;
                  };
                };
                options.desc = layout.desc;
              });
            replTerminals =
              [
                {
                  prefix = prefix.term;
                }
                {
                  prefix = prefix.repl + "p";
                  cmd = "python";
                }
                {
                  prefix = prefix.repl + "i";
                  cmd = "ipython --no-confirm-exit --no-autoindent";
                }
                {
                  prefix = prefix.repl + "j";
                  cmd = "julia";
                }
                {
                  prefix = prefix.repl + "r";
                  cmd = "R --no-save";
                }
              ]
              |> lib.imap1 (
                i: spec:
                allLayouts {
                  inherit (spec) prefix;
                  cmd = spec.cmd or null;
                  count = i + 2; # INFO: Counts continue after lazygit (1) and btop (2)
                }
              )
              # INFO: imap1 returns one list per repl spec (3 layouts each), so flatten
              # collapses the nested list-of-lists into the flat keymap list that
              # `++` and the trailing lib.map expect.
              |> lib.flatten;

          in
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
              mode = [
                "n"
                "i"
                "t"
              ];
              options.desc = "Toggle last terminal";
            }
          ]
          ++ optional lazygit.enable {
            key = prefix.term + "l";
            action = toggleTerm {
              cmd = toString lazygit.package;
              opts.count = 1;
            };
            options.desc = "Lazygit";
          }

          ++ optional config.programs.btop.enable {
            key = prefix.term + "b";
            action = toggleTerm {
              cmd = toString btop.package;
              opts.count = 2;
            };
            options.desc = "Btop";
          }
          ++ replTerminals
          |> lib.map (m: m // { mode = m.mode or "n"; });

      };
  };
}
