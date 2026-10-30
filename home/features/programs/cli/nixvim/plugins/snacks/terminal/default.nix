{
  config,
  lib,
  ...
}: let
  enable = true;
in {
  _module.args.snacksTerminal = {
    inherit enable;
    toggleTerm = import ./_toggle-term.nix {inherit config lib;};
  };

  programs.nixvim.plugins.snacks.settings.terminal.enabled = enable;
}
