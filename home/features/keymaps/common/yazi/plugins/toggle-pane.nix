{ config, lib, ... }:
let
  cfg = config.programs.yazi.plugins;
  plugin = "toggle-pane";
in
{
  # INFO: max-preview was deprecated upstream and folded into toggle-pane,
  # so the maximize/restore action is now `plugin toggle-pane max-preview`.
  programs.yazi.keymap.mgr.prepend_keymap = lib.mkIf (lib.hasAttr plugin cfg) [
    {
      on = [ "P" ];
      run = "plugin ${plugin} max-preview";
      desc = "Maximize or restore preview";
    }
  ];
}
