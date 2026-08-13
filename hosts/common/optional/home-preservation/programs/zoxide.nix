{
  hmConfig,
  persistentPath,
  username,
  lib,
  ...
}:
{
  preservation.preserveAt.${persistentPath}.users.${username}.directories =
    lib.mkIf hmConfig.programs.zoxide.enable
      [
        ".local/share/zoxide"
      ];
}
