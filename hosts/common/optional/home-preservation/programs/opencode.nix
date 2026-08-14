{
  hmConfig,
  persistentPath,
  username,
  lib,
  ...
}:
{
  preservation.preserveAt.${persistentPath}.users.${username}.directories =
    lib.mkIf hmConfig.programs.opencode.enable
      [
        ".local/share/opencode"
        ".local/state/opencode"
        ".cache/opencode"
      ];
}
