{
  hmConfig,
  persistentPath,
  username,
  lib,
  ...
}:
{
  preservation.preserveAt.${persistentPath}.users.${username}.files =
    lib.mkIf (hmConfig ? sops && hmConfig.sops.age.keyFile != null)
      [
        {
          file = lib.removePrefix "${hmConfig.home.homeDirectory}/" hmConfig.sops.age.keyFile;
          mode = "0600";
          how = "symlink";
          configureParent = true;
        }
      ];
}
