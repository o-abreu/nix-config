{ persistentPath, ... }: {

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  boot = {
    initrd.systemd.enable = true;
    tmp.cleanOnBoot = true;
  };

  preservation = {
    enable = true;
    preserveAt.${persistentPath} = {
      directories = [
        "/etc/secureboot"
        "/etc/NetworkManager/system-connections"
        "/var/lib/bluetooth"
        "/var/lib/fprint"
        "/var/lib/fwup"
        "/var/lib/libvirt"
        "/var/lib/power-profiles-daemon"
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/rfkill"
        "/var/lib/systemd/timers"
        "/var/log"
        {
          directory = "/tmp";
          mode = "1777";
          user = "root";
          group = "root";
        }
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
      ];
      files = [
        {
          file = "/etc/ssh/ssh_host_rsa_key";
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/etc/ssh/ssh_host_ed25519_key";
          how = "symlink";
          configureParent = true;
        }
        "/var/lib/usbguard/rules.conf"

        {
          file = "/var/lib/systemd/random-seed";
          how = "symlink";
          inInitrd = true;
          configureParent = true;
        }
      ];

      users.root.directories = [
        {
          directory = ".ssh";
          mode = "0700";
        }
      ];
    };
  };
}
