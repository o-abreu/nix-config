{
  config,
  hmConfig,
  persistentPath,
  username,
  lib,
  ...
}:
{
  preservation.preserveAt.${persistentPath}.users.${username}.directories =
    lib.mkIf (config.programs.comma.enable or false || hmConfig.programs.comma.enable or false)
      [
        ".local/state/comma"
      ];
}
