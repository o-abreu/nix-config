{
  hmConfig,
  persistentPath,
  username,
  lib,
  ...
}:
{
  preservation.preserveAt.${persistentPath}.users.${username} =
    lib.mkIf hmConfig.programs.qalculate.enable
      {
        directories = [ ".local/share/qalculate" ];
        files = [
          ".config/qalculate/qalc.cnf"
          ".local/state/qalculate/qalc.history"
        ];
      };
}
