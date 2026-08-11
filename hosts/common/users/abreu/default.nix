{
  config,
  inputs,
  lib,
  outputs,
  pkgs,
  ...
}: let
  username = "abreu";
  relativeFlakePath = ".config/nix-config";
  flakePath = "/home/${username}/${relativeFlakePath}";
in {

  _module.args = {
    username = username;
    relativeFlakePath = relativeFlakePath;
  };

  imports = [
    inputs.home-manager.nixosModules.default
    ../_homePreservation.nix
  ];

  programs = {
    nh = {
      enable = true;
      flake = flakePath;
    };
    fish = {
      enable = true;
      shellAbbrs.nos = "sudo -v && nh os switch -- --show-trace";
    };
  };

  # Extends sudo credential cache to 6 hours, so that "sudo -v" at the start of the update command can last through the entire build time, even if it is very long.
  security.sudo.extraConfig = "Defaults timestamp_timeout=360";

  users.users.${username} = {
    shell = config.programs.fish.package;
    isNormalUser = true;
    description = "Abreu";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
    ];

    # INFO: The following line explicitly installs the home-manager CLI tool.
    # Even though it should not be used for system updates in a NixOS settings,
    # it is still useful to read documentation (`man home-configuration.nix`) and
    # the inspection of the current generation.
    packages = [ pkgs.sops ];
    hashedPasswordFile = config.sops.secrets.rootPassword.path;
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = username;
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;
    extraSpecialArgs = {
      inherit inputs outputs flakePath;
      system = pkgs.stdenv.hostPlatform.system;
    };
    sharedModules = [
      (
        { osConfig, ... }:
        {
          nixpkgs.overlays = lib.mkOrder 900 osConfig.nixpkgs.overlays;
        }
      )
    ];
    users.${username} = import "${inputs.self}/home/${username}/${config.networking.hostName}";
  };
}
