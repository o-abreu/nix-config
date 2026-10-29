{
  lib,
  opencode,
  snacksTerminal,
  ...
}: let
  action = snacksTerminal.toggleTerm {
    cmd = opencode.cmd;
    listed = true;
    name = "Opencode";
    opts = {
      # Distinct snacks slot: lazygit 1, btop 2, float/splits 3, REPLs 4-6.
      count = 8;
      win.position = "current";
    };
  };
in {
  programs.nixvim.keymaps = lib.optionals (opencode.enable && snacksTerminal.enable) [
    {
      inherit action;
      key = opencode.prefix + "t";
      mode = "n";
      options.desc = "Toggle buffer";
    }

    {
      inherit action;
      key = "<C-.>";
      mode = ["n" "t"];
      options.desc = "Toggle opencode buffer";
    }
  ];
}
