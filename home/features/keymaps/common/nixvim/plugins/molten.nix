{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib) mkIf flip genAttrs;
  inherit (config.programs.nixvim.plugins) molten;
  prefix = "<leader>m";
  cmd = c: "<cmd>Molten${c}<cr>";
in
{
  config = mkIf (options ? programs.nixvim) {
    programs.nixvim = {
      files =
        [
          "python"
          "quarto"
          "markdown"
        ]
        |> map (ft: "ftplugin/${ft}.lua")
        |> flip genAttrs (_: {
          keymaps = map (m: m // { mode = "n"; }) [
            {
              key = prefix + "e";
              action = cmd "EvaluateOperator";
              options.desc = "Run operator selection";
            }
            {
              key = prefix + "l";
              action = cmd "EvaluateLine";
              options.desc = "Evaluate line";
            }
            {
              key = prefix + "c";
              action = cmd "ReevaluateCell";
              options.desc = "Re-evaluate cell";
            }
            {
              key = prefix + "i";
              action = cmd "Init";
              options.desc = "Initialize the plugin";
            }
            {
              key = prefix + "h";
              action = cmd "HideOutput";
              options.desc = "Hide output";
            }
            {
              key = prefix + "I";
              action = cmd "Interrupt";
              options.desc = "Interrupt kernel";
            }
            {
              key = prefix + "R";
              action = cmd "Restart";
              options.desc = "Restart kernel";
            }
            {
              key = prefix + "p";
              action = cmd "InitVenv";
              options = {
                silent = true;
                desc = "Initialize for Python venv";
              };
            }
            {
              key = prefix + "r";
              action = ":<C-u>MoltenEvaluateVisual<cr>gv";
              options.desc = "Evaluate visual selection";
              mode = "v";
            }
            {
              key = "]c";
              action = cmd "Next";
              options.desc = "Next Molten cell";
            }
            {
              key = "[c";
              action = cmd "Prev";
              options.desc = "Previous Molten cell";
            }
          ];
        })
        |> mkIf molten.enable;

      plugins.which-key.settings.spec = mkIf molten.enable [
        {
          __unkeyed-1 = prefix;
          mode = [
            "n"
            "v"
          ];
          group = "Molten";
          icon = "󱓞";
        }
      ];
    };
  };
}
