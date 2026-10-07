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

    # INFO: `auth0.allenai.org` resolves to two Cloudflare anycast IPv6
    # addresses, and one of them (2a06:98c1:310d::6812:2bb6) is intermittently
    # unreachable from this network while the other -- and general IPv6 to
    # Google/Cloudflare -- works. Clients that don't retry across resolved
    # addresses (Python's httpx, used by `asta`) then fail with a bare
    # "Network error". Prefer IPv4 in getaddrinfo(3) so they take the healthy
    # IPv4 anycast path. The full RFC 3484 table is required because providing
    # any precedence disables glibc's default table.
    getaddrinfo = {
      enable = true;
      precedence = {
        "::1/128" = 50;
        "::/0" = 40;
        "2002::/16" = 30;
        "::/96" = 20;
        "::ffff:0:0/96" = 100;
      };
    };
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
