# TODO: Merge this configuration with the one defined in cli/git, using sops.template to generate the final config file instead of home-manager's git.settings.
{ config, ... }:
let
  sshKey = ".ssh/git";
  homeDir = config.home.homeDirectory;
in
{
  sops.secrets = {
    "ssh-keys/github/private" = {
      path = "${homeDir}/.ssh/git";
      mode = "0600";
    };
    "ssh-keys/github/password" = {
      mode = "0600";
    };
    "api-keys/github" = {
      mode = "0600";
    };
  };

  home.file."${sshKey}.pub".text = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAWdwXxSon1mmnLIC9CKByWYM6tYapsawQ/AwsV1TC+x Github
  '';

  programs = {
    git = {
      settings = {
        user = {
          name = "Abreu";
          email = "87032834+de-abreu@users.noreply.github.com";
        };
      };
      signing = {
        format = "ssh";
        key = "${homeDir}/${sshKey}.pub";
        signByDefault = true;
      };
    };
    fish.shellInit = ''
      export GH_TOKEN=(cat ${config.sops.secrets."api-keys/github".path})
    '';
  };

  services.ssh-agent.addKeys = [
    {
      path = "${homeDir}/${sshKey}";
      passwordSecret = "ssh-keys/github/password";
    }
  ];
}
