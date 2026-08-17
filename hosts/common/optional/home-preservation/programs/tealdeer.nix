{
  hmConfig,
  persistentPath,
  username,
  lib,
  ...
}:
{
  preservation.preserveAt.${persistentPath}.users.${username}.directories =
    lib.mkIf hmConfig.programs.tealdeer.enable
      [
        ".cache/tealdeer"
      ];
}
