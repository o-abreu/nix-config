{
  pkgs,
  lib,
  ...
}: let
  lazyLoad.settings.ft = ["python"];
in {
  programs.nixvim.plugins =
    {
      lint = {
        lintersByFt.python = ["mypy"];
        linters.mypy = {
          cmd = lib.getExe pkgs.mypy;
          args = ["--ignore-missing-imports"];
        };
      };

      venv-selector = {
        enable = true;
        inherit lazyLoad;
      };

      dap-python = {
        enable = true;
        inherit lazyLoad;
      };
    }
    // (lib.genAttrs ["dap" "dap-ui" "dap-virtual-text"] (_: {inherit lazyLoad;}));
}
