{
  config,
  lib,
  ...
}:
{
  programs.nixvim.plugins =
    let
      cfg = config.programs.nixvim.plugins.neotest;
      prefix = "<leader>T";
      watchPrefix = "<leader>w";
      mkAction = action: { __raw = "function() require('neotest').${action} end"; };
    in
    {
      which-key.settings.spec = lib.mkIf cfg.enable [
        {
          __unkeyed-1 = prefix;
          mode = "n";
          group = "Tests";
          icon = "";
        }

        {
          __unkeyed-1 = watchPrefix;
          mode = "n";
          group = "Watch";
          icon = "";
        }
      ];

      neotest.lazyLoad.settings.keys =
        [
          {
            __unkeyed-1 = prefix + "a";
            __unkeyed-2 = mkAction "run.attach()";
            desc = "Attach test";
          }

          {
            __unkeyed-1 = prefix + "t";
            __unkeyed-2 = mkAction "run.run()";
            desc = "Run test";
          }

          {
            __unkeyed-1 = prefix + "d";
            __unkeyed-2 = mkAction "run.run { strategy = 'dap' }";
            desc = "Debug test";
          }

          {
            __unkeyed-1 = prefix + "f";
            __unkeyed-2 = mkAction "run.run(vim.fn.expand('%'))";
            desc = "Run all tests in file";
          }

          {
            __unkeyed-1 = prefix + "p";
            __unkeyed-2 = mkAction "run.run(vim.fn.getcwd())";
            desc = "Run all projects in project";
          }

          {
            __unkeyed-1 = prefix + "<cr>";
            __unkeyed-2 = mkAction "summary.toggle()";
            desc = "Test Summary";
          }

          {
            __unkeyed-1 = prefix + "o";
            __unkeyed-2 = mkAction "output.open()";
            desc = "Output hover";
          }

          {
            __unkeyed-1 = prefix + "O";
            __unkeyed-2 = mkAction "output_panel.toggle()";
            desc = "Output window";
          }

          {
            __unkeyed-1 = "]T";
            __unkeyed-2 = mkAction "jump.next()";
            desc = "Next test";
          }

          {
            __unkeyed-1 = "[T";
            __unkeyed-2 = mkAction "jump.prev()";
            desc = "Previous test";
          }

          {
            __unkeyed-1 = watchPrefix + "t";
            __unkeyed-2 = mkAction "watch.toggle()";
            desc = "Toggle watch test";
          }

          {
            __unkeyed-1 = watchPrefix + "f";
            __unkeyed-2 = mkAction "watch.toggle(vim.fn.expand('%'))";
            desc = "Toggle watch all tests in file";
          }

          {
            __unkeyed-1 = watchPrefix + "p";
            __unkeyed-2 = mkAction "watch.toggle(vim.fn.getcwd())";
            desc = "Toggle watch all tests in project";
          }

          {
            __unkeyed-1 = watchPrefix + "s";
            __unkeyed-2 = mkAction "stop()";
            desc = "Stop all watches";
          }
        ]
        |> map (m: m // { mode = m.mode or "n"; });
    };
}
