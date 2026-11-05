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
      # Enabled by an explicit `enable`, or implied by any contributed package.
      python = optional
        (cfg.python.enable || cfg.python.withPackages != [ ])
        (cfg.python.package.withPackages (_: cfg.python.withPackages));
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
        runtimeInputs =
          # Prepended, not appended: other modules (tools/asta) already put a
          # bare `python3` on PATH, and the first match wins. The wrapped
          # interpreter must shadow it or its packages are unreachable.
          python
          ++ cfg.extraPackages
          ++ optional (cfg ? settings.plugin) pkgs.bun;
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
