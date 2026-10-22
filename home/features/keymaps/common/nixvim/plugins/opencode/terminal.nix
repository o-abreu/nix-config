{
  config,
  lib,
  opencode,
  ...
}: let
  inherit (config.programs.nixvim.plugins) snacks;
  action.__raw =
    # lua
    ''
      function()
        require('snacks.terminal').toggle('${opencode.cmd}', { win = { position = 'right', enter = false } })
      end
    '';
in {
  programs.nixvim.keymaps = lib.optionals (opencode.enable && snacks.enable) [
    {
      inherit action;
      key = opencode.prefix + "t";
      mode = "n";
      options.desc = "Toggle window";
    }

    {
      inherit action;
      key = "<C-.>";
      mode = ["n" "t"];
      options.desc = "Toggle opencode window";
    }
  ];
}
