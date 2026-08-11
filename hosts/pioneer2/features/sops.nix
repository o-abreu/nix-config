{
  inputs,
  config,
  persistentPath,
  ...
}:
let
  ageKeyFile = "/var/lib/sops-nix/age/keys.txt";
in
{
  sops = {
    age.keyFile = "${persistentPath}${ageKeyFile}";
    defaultSopsFormat = "yaml";
    defaultSopsFile = "${inputs.self}/secrets/hosts/${config.networking.hostName}.yaml";
    secrets.rootPassword.neededForUsers = true;
  };

  users.users.root.hashedPasswordFile = config.sops.secrets.rootPassword.path;
  environment.shellAliases.sops-host = "sudo SOPS_AGE_KEY_FILE=${ageKeyFile} sops";
  
  # WARNING: Sops needs secrets available early at boot in order to setup root and user passwords.
  fileSystems.${persistentPath}.neededForBoot = true; 
  preservation.preserveAt.${persistentPath}.files = [
    {
      file = ageKeyFile;
      inInitrd = true;
      how = "symlink";
      configureParent = true;
    }
  ];
}
