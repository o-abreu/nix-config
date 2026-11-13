{
  inputs,
  outputs,
  config,
  ...
}: {
  imports = with inputs;
    [
      sops-nix.homeModules.sops
      vortriz-nur.homeModules.zotero

      (import-tree [../../features])
      ../_git.nix
    ]
    # Custom modules
    ++ (builtins.attrValues outputs.modules.homeManager);

  home = {
    username = "abreu";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "25.05";
  };

  xdg = {
    mimeApps.enable = true;
    userDirs = {
      enable = true;
      setSessionVariables = false;
      createDirectories = true;
    };
  };

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = "${inputs.self}/secrets/users/${config.home.username}.yaml";
  };
}
