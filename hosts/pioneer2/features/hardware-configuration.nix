{
  inputs,
  lib,
  modulesPath,
  ...
}:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disko.nix

    # Optimized hardware profiles for the AMD Slimbook Excalibur
    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-amd
    common-pc-laptop
    common-pc-ssd
  ];
  
  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = [ "kvm-amd" ];
  };

  hardware.tuxedo-drivers.enable = true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
