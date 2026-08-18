{ inputs, ... }: {
  imports = [ inputs.noctalia.nixosModules.default ];

  programs = {
    noctalia = {
      enable = true;
      recommandedServices.enable = true;
    };
    hyprland.enable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
