{
  inputs,
  persistentPath,
  ...
}: {
  imports = [ inputs.disko.nixosModules.default ];
  
  disko.devices = {
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "defaults"
          "size=25%"
          "mode=755"
        ];
      };
    };
    
    disk.main = {
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
            name = "ESP";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          luks = {
            priority = 2;
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              settings.allowDiscards = true;
              
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  
                  "/system" = {
                    mountpoint = persistentPath;
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  
                  "/home" = {
                    mountpoint = "${persistentPath}/home";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  
                  "/swap" = {
                    mountpoint = "/.swapvol";
                    swap.swapfile.size = "34G";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
