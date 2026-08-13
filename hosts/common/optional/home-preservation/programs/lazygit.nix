{
  hmConfig,
  persistentPath,
  username,
  lib,
  ...
}:
{
  preservation.preserveAt.${persistentPath}.users.${username}.files =
    lib.mkIf hmConfig.programs.lazygit.enable
      [
        ".local/share/lazygit/state.yml"
      ];
}
