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
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    libinput.enable = true;
  };

  sops.secrets.uspnet-vpn = { };

  programs = {
    kanata = {
      devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
      addBinaryToPath = true;
    };
    openfortivpn.configFile = config.sops.secrets.uspnet-vpn.path;
  };

  users.mutableUsers = false;

  system.stateVersion = "26.05";
}
