{
  config,
  lib,
  ...
}: {
  programs.nixvim = let
    cfg = config.programs.nixvim.plugins.crazy-coverage;
    prefix = "<leader>TC";
    togglePrefix = "<leader>uC";
    mkCmd = cmd: "<cmd>Coverage${cmd}<cr>";
  in {
    plugins.which-key.settings.spec =
      lib.optionals cfg.enable [
        {__unkeyed-1 = prefix;}
        {__unkeyed-1 = togglePrefix;}
      ]
      |> map (
        m:
          m
          // {
            mode = "n";
            group = "Coverage";
            icon = "";
          }
      );

    keymaps = let
      toggles = [
        {
          key = togglePrefix + "<cr>";
          action = mkCmd "Toggle";
          options.desc = "Toggle coverage overlay";
        }
        {
          key = togglePrefix + "h";
          action = mkCmd "ToggleHitCount";
          options.desc = "Toggle hit count";
        }
        {
          key = togglePrefix + "s";
          action = mkCmd "ToggleSignColumn";
          options.desc = "Toggle sign column";
        }
        {
          key = togglePrefix + "b";
          action = mkCmd "ToggleBranchOverlay";
          options.desc = "Toggle branch overlay";
        }
        {
          key = togglePrefix + "r";
          action = mkCmd "ToggleRegionOverlay";
          options.desc = "Toggle region overlay";
        }
      ];
      navigation = [
        {
          key = "]Cc";
          action = mkCmd "NextCovered";
          options.desc = "Next covered line";
        }
        {
          key = "[Cc";
          action = mkCmd "PrevCovered";
          options.desc = "Previous covered line";
        }
        {
          key = "]Cu";
          action = mkCmd "NextUncovered";
          options.desc = "Next uncovered line";
        }
        {
          key = "[Cu";
          action = mkCmd "PrevUncovered";
          options.desc = "Previous uncovered line";
        }
        {
          key = "]Cp";
          action = mkCmd "NextPartial";
          options.desc = "Next partial line";
        }
        {
          key = "[Cp";
          action = mkCmd "PrevPartial";
          options.desc = "Previous partial line";
        }
      ];
    in
      [
        {
          key = prefix + "s";
          action = mkCmd "Summary";
          options.desc = "Show coverage summary";
        }
        {
          key = prefix + "l";
          action = mkCmd "Load";
          options.desc = "Manually load a specific coverage file";
        }
      ]
      ++ toggles
      ++ navigation
      |> map (
        m:
          m
          // {
            mode = m.mode or "n";
            options.silent = true;
          }
      )
      |> lib.optionals cfg.enable;
  };
}
