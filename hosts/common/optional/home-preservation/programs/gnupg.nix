{
  hmConfig,
  persistentPath,
  username,
  lib,
  ...
}:
{
  preservation.preserveAt.${persistentPath}.users.${username}.directories =
    lib.mkIf hmConfig.programs.gpg.enable
      [
        {
          directory = ".gnupg";
          mode = "0700";
        }
      ];
}
