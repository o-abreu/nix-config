{
  hmConfig,
  persistentPath,
  username,
  lib,
  ...
}:
{
  preservation.preserveAt.${persistentPath}.users.${username}.directories =
    lib.mkIf hmConfig.programs.fish.enable
      [
        ".local/share/fish"
      ];
}
