{
  config,
  lib,
  ...
}: let
  cfg = config.programs.nixvim.plugins.dap;
in {
  programs.nixvim = {
    plugins = {
      dap-ui = {inherit (cfg) enable;};
      dap-virtual-text = {inherit (cfg) enable;};

      dap.lazyLoad.settings.after =
        lib.mkIf cfg.enable
        # lua
        ''
          function()
            ${cfg.luaConfig.content}

            local dap, dapui = require "dap", require "dapui"

            dap.listeners.after.event_initialized["dapui_config"] = function()
              dapui.open()
            end
          end
        '';
    };
  };
}
