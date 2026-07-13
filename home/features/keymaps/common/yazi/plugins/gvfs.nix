{
  config,
  lib,
  ...
}:
let
  cfg = config.programs.yazi.plugins;
  plugin = "gvfs";
in
{
  programs.yazi.keymap.mgr.prepend_keymap = lib.mkIf (lib.hasAttr plugin cfg) [
    {
      on = [ "M" "m" ];
      run = "plugin ${plugin} -- select-then-mount --jump";
      desc = "Mount device and jump to mount point";
    }
    {
      on = [ "M" "u" ];
      run = "plugin ${plugin} -- select-then-unmount --eject";
      desc = "Unmount and eject device";
    }
    {
      on = [ "M" "U" ];
      run = "plugin ${plugin} -- select-then-unmount --eject --force";
      desc = "Force eject/unmount device";
    }
    {
      on = [ "M" "a" ];
      run = "plugin ${plugin} -- add-mount";
      desc = "Add a GVFS mount URI";
    }
    {
      on = [ "M" "e" ];
      run = "plugin ${plugin} -- edit-mount";
      desc = "Edit a GVFS mount URI";
    }
    {
      on = [ "M" "r" ];
      run = "plugin ${plugin} -- remove-mount";
      desc = "Remove a GVFS mount URI";
    }
    {
      on = [ "M" "R" ];
      run = "plugin ${plugin} -- remount-current-cwd-device";
      desc = "Remount device under cwd";
    }
    {
      on = [ "M" "t" ];
      run = "plugin ${plugin} -- automount-when-cd";
      desc = "Enable automount when cd";
    }
    {
      on = [ "M" "T" ];
      run = "plugin ${plugin} -- automount-when-cd --disabled";
      desc = "Disable automount when cd";
    }
    {
      on = [ "g" "m" ];
      run = "plugin ${plugin} -- jump-to-device";
      desc = "Jump to device mount point";
    }
    {
      on = [ "`" "`" ];
      run = "plugin ${plugin} -- jump-back-prev-cwd";
      desc = "Jump back to previous cwd";
    }
  ];
}
