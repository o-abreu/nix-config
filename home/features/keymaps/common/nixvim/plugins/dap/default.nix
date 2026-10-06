{
  config,
  lib,
  ...
}: let
  inherit (config.programs.nixvim.plugins) dap dap-ui which-key;
  prefix = "<leader>d";
  filetypes = dap.lazyLoad.settings.ft or [];
in {
  _module.args.dap = {
    inherit (dap) enable;
    inherit prefix filetypes;
    ui.enable = dap-ui.enable;
    oneShot = cmd: "function() require('dap').${cmd}() end";
    bind = {
      key,
      action,
      desc,
      mode ? "n",
    }: {
      inherit key mode;
      action.__raw = action;
      options = {
        buffer = true;
        inherit desc;
      };
    };
  };

  programs.nixvim = {
    files =
      filetypes
      |> map (ft: "ftplugin/${ft}.lua")
      |> lib.flip lib.genAttrs (_: {
        extraConfigLua =
          lib.mkIf (dap.enable && which-key.enable)
          ''
            require("which-key").add({
              {
                "${prefix}",
                group = "Debugger",
                mode = { "n", "v" },
                buffer = true,
              },
            })
          '';
      });

    assertions = [
      {
        assertion = !dap.enable || filetypes != [];
        message = ''
          programs.nixvim.plugins.dap is enabled but no filetype declares a DAP
          adapter, so no ftplugin received the debugger keybinds. Declare
          `plugins.dap.lazyLoad.settings.ft` in the module that adds the adapter
          (see home/features/programs/cli/nixvim/plugins/language-support/python/default.nix).
        '';
      }
    ];
  };
}
