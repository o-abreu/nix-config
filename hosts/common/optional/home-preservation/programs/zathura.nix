{
  hmConfig,
  persistentPath,
  username,
  lib,
  ...
}:
{
  preservation.preserveAt.${persistentPath}.users.${username}.directories =
    lib.mkIf hmConfig.programs.zathura.enable
      [
        ".local/share/zathura"
        ".cache/zathura"
      ];
}
