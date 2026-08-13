{
  config,
  pkgs,
  lib,
  options,
  ...
}:
let
  cfg = config.services.ssh-agent;
  sshAdd = lib.getExe' config.services.ssh-agent.package "ssh-add";
  hasPassword = key: key.passwordSecret != null;

  # Helper function to generate bash commands to load each key
  mkAddKey =
    key:
    let
      keyName = lib.strings.sanitizeDerivationName (baseNameOf key.path);
    in
    if hasPassword key then
      let
        # Fetch secret path or fallback to empty string safely if sops isn't imported
        # Prevents raw Nix evaluation errors so that the assertion error can be displayed.
        secretPath = if options ? sops then config.sops.secrets.${key.passwordSecret}.path else "";
        askpassScript = pkgs.writeShellScript "ssh-askpass-${keyName}" ''
          cat ${secretPath}
        '';
      in
      # bash
      ''
        if [ -f "${key.path}" ]; then
          echo "Adding key with passphrase: ${key.path}"
          SSH_ASKPASS_REQUIRE=force SSH_ASKPASS="${askpassScript}" ${sshAdd} "${key.path}"
        else
          echo "Key file not found: ${key.path}" >&2
        fi
      ''
    else
      # bash
      ''
        if [ -f "${key.path}" ]; then
          echo "Adding key: ${key.path}"
          ${sshAdd} "${key.path}" < /dev/null
        else
          echo "Key file not found: ${key.path}" >&2
        fi
      '';

  sshAddAllScript = pkgs.writeShellScript "ssh-add-all-keys" ''
    ${lib.concatMapStringsSep "\n" mkAddKey cfg.addKeys}
  '';
in
{
  config = lib.mkIf (cfg.addKeys != [ ]) {
    services.ssh-agent.enable = lib.mkDefault true;

    assertions = [
      {
        assertion = lib.any hasPassword cfg.addKeys -> (options ? sops);
        message = "`services.ssh-agent.addKeys` requires the `sops-nix` module to be imported and configured whenever one or more SSH keys specify a `passwordSecret`.";
      }
    ];

    systemd.user.services.ssh-add = {
      Unit =
        let
          dependencies = [
            "ssh-agent.service"
            "sops-nix.service"
          ];
        in
        {
          Description = "Adds SSH private keys to the ssh-agent";
          After = dependencies;
          Wants = dependencies;
          ConditionEnvironment = [ "XDG_RUNTIME_DIR" ];
        };

      Service = {
        Type = "oneshot";
        Environment = [ "SSH_AUTH_SOCK=%t/ssh-agent" ];
        ExecStart = "${sshAddAllScript}";
        RemainAfterExit = true;
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
