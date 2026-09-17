{
  hmConfig,
  persistentPath,
  username,
  lib,
  ...
}:
let
  inherit (lib) mkIf nameValuePair;
  cfg = hmConfig.programs.nixvim.plugins;
  dataDir = ".local/share/jupyter";
  enabled = (cfg.molten.enable or false) || (cfg.vim-slime.enable or false);
in
{
  config = {
    preservation.preserveAt.${persistentPath}.users.${username}.directories = mkIf enabled [ dataDir ];

    # Ensure directories exist on fresh environments (new installs, empty
    # persistent volumes) before the preservation bind-mounts land.
    systemd.tmpfiles.settings.jupyter = mkIf enabled (
      [
        ""
        "kernels"
        "runtime"
      ]
      |> map (
        dir:
        nameValuePair "${dataDir}/${dir}" {
          d = {
            user = username;
            group = "users";
            mode = "0755";
          };
        }
      )
      |> builtins.listToAttrs
    );
  };
}
