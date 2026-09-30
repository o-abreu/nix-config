{
  config,
  lib,
  snacksTerminal,
  ...
}:
with snacksTerminal;
let
  inherit (config.programs) lazygit;
in
{
  programs.nixvim.keymaps = lib.optional lazygit.enable {
    key = prefix + "l";
    action = toggleTerm {
      cmd = lib.getExe lazygit.package;
      opts.count = 1;
    };
    mode = "n";
    options.desc = "Lazygit";
  };
}
