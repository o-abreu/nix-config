{
  hmConfig,
  persistentPath,
  lib,
  ...
}:
{
  preservation.preserveAt.${persistentPath}.users.${hmConfig.home.username} =
    lib.mkIf hmConfig.programs.qalculate.enable
      {
        directories = [ ".local/share/qalculate" ];
        files = [
          ".config/qalculate/qalc.cnf"
          ".local/state/qalculate/qalc.history"
        ];
      };
}
