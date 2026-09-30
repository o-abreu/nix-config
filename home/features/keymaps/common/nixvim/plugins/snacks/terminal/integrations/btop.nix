{
  config,
  lib,
  snacksTerminal,
  ...
}:
with snacksTerminal;
let
  btop = config.programs.btop;
in
{
  programs.nixvim.keymaps = lib.optional btop.enable {
    key = prefix + "b";
    action = toggleTerm {
      cmd = lib.getExe btop.package;
      opts.count = 2;
    };
    mode = "n";
    options.desc = "Btop";
  };
}
