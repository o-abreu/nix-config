{ lib, ... }:
with lib;
{
  options.services.ssh-agent.addKeys =
    with types;
    mkOption {
      type = listOf (submodule {
        options = {
          path = mkOption {
            type = str;
            example = "\${config.home.homeDirectory}/.ssh/id_ed25519";
            description = "Absolute path to the SSH private key.";
          };

          passwordSecret = mkOption {
            type = nullOr str;
            default = null;
            example = "ssh-keys/github/password";
            description = ''
              Path to the SOPS secret key containing the password.
              Set to `null` if the key has no password.
            '';
          };
        };
      });
      default = [ ];
      description = "List of SSH private keys to load authomatically into ssh-agent at login.";
    };
}
