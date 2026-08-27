{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  _module.args.persistentPath = "/persistent";

  imports =
    with inputs;
    [
      sops-nix.nixosModules.sops # Secrets management module
      preservation.nixosModules.default # Impermanence module
      nix-index-database.nixosModules.nix-index # Access to "comma" tool
      noctalia.nixosModules.default # Desktop Environment
      noctalia-greeter.nixosModules.default # Login manager

      (import-tree [
        ./features
        ../common/users
      ])
    ]
    # Custom modules
    ++ (lib.attrValues outputs.nixosModules);

  nixpkgs.overlays = lib.attrValues outputs.overlays;

  networking = {
    hostName = "pioneer2";
    networkmanager.enable = true;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services = {
    xserver.enable = true;
    libinput.enable = true;
    gvfs.enable = true; # INFO: Enable mounting of external volumes
  };

  sops.secrets.uspnet-vpn = { };

  programs = {
    hyprland = {
      mirrorToggle.main = "eDP-1";
      touchpadToggle.name = "HTIX5288:00 36B6:C001 Touchpad";
    };
    kanata = {
      devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
      addBinaryToPath = true;
    };
    openfortivpn.configFile = config.sops.secrets.uspnet-vpn.path;
    nix-index-database.comma.enable = true;
  };

  users.mutableUsers = false;
  system.stateVersion = "26.05";
}
