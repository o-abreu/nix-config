{ config, lib, ... }: {
  programs.nixvim =
    let
      inherit (config.programs.nixvim.plugins) which-key;
      enable = lib.mkIf which-key.enable;
    in
    {
      plugins.which-key.settings.disable.ft = enable [ "alpha" ];

      autoGroups = enable {
        alpha_keybind_lock.clear = true;
        alpha_startup.clear = true;
      };

      files."lua/alpha/whitelist-keybinds.lua".extraConfigLua =
        builtins.readFile ./whitelist-keybinds/init.lua;

      autoCmd =
        let
          lockDashboard = {
            __raw =
              # lua
              ''
                function(args)
                  vim.schedule(function()
                    require("alpha.whitelist-keybinds").lock(args.buf)
                  end)
                end
              '';
          };
        in
        enable [
          {
            event = "FileType";
            pattern = "alpha";
            group = "alpha_keybind_lock";
            desc = "Block all keymaps on the Alpha dashboard except its buttons";
            callback = lockDashboard;
          }
          {
            event = "User";
            pattern = "AlphaRemap";
            group = "alpha_keybind_lock";
            desc = "Re-apply the Alpha dashboard keymap lock";
            callback = lockDashboard;
          }
        ];
    };
}
