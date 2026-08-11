{
  inputs,
  outputs,
  config,
  ...
}:
{
  imports =
    with inputs;
    [
      sops-nix.homeManagerModules.sops
      vortriz-nur.homeModules.zotero

      (import-tree [
        ../../features/desktop-environment/stylix
        ../../features/keymaps
        ../../features/programs
      ])

      ../_git.nix
    ]
    # Custom modules
    ++ (builtins.attrValues outputs.homeModules);

  home = {
    username = "abreu";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "25.05";
  };

  xdg.userDirs.setSessionVariables = false;

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = "${inputs.self}/secrets/users/${config.home.username}.yaml";
  };
}
