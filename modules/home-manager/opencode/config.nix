{
  config,
  lib,
  pkgs,
  wrappers ? throw "programs.opencode: missing the `wrappers` module argument (import flake.modules.homeManager.wrappers)",
  ...
}:
with lib;
{
  config =
    let
      cfg = config.programs.opencode;
      opencode-wrapped = wrappers.wrapPackage {
        inherit pkgs;
        package = pkgs.opencode;
        preHook =
          mapAttrsToList (name: secretPath: ''
            ${name}="$(cat ${config.sops.secrets.${secretPath}.path})" || exit 1
            export ${name}
            readonly ${name}
          '') cfg.env.apiKeys
          |> concatStringsSep "\n";
        runtimeInputs = cfg.extraPackages ++ optional (cfg ? settings.plugin) pkgs.bun;
        flags = optionalAttrs (cfg ? settings.server.port) {
          "--port" = toString cfg.settings.server.port;
        };
        env = mapAttrs (_: toString) cfg.env.vars;
      };
    in
    {
      sops.secrets = genAttrs (attrValues cfg.env.apiKeys) (_: { });
      programs.opencode.package = opencode-wrapped;
    };
}
