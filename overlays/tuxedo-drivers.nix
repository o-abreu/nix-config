# Bump tuxedo-drivers for Linux 7.3 compatibility and fix module-signing
# make-flag regression (kmodigest).
#
# Two independent upstream breakages hit this package at nixos-unstable
# 02c087f (see NixOS/nixpkgs#576266):
#
# 1. kernelModuleMakeFlags now sets `cmd_sign=.../kmodigest$(space)$@`
#    (kmodigest signing, NixOS/nixpkgs#571181). tuxedo-drivers' own
#    `Makefile` re-expands `$(MAKEFLAGS)` textually instead of using `$(MAKE)`
#    recursion, so the literal `$(space)` reaches bash → `syntax error near
#    unexpected token '('`.
# 2. Linux 7.3 removed `struct acpi_driver.drv`, which tuxedo-drivers 4.20.1
#    never rebuilds; 4.25.0 is the first release with the API change handled.
#
# Upstream moved `usr/` to `files/usr/` in release 4.21.0, so tuxedo-drivers'
# `postInstall` path references are rewritten accordingly. Keep this overlay
# until the package lands at ≥ 4.25.0 in nixpkgs (r-ryantm update tracking:
# https://nixpkgs-update-logs.nixos.org/linuxPackages.tuxedo-drivers/).
final: prev: {
  linuxPackages_latest = prev.linuxPackages_latest.extend (kfinal: kprev: {
    tuxedo-drivers = kprev.tuxedo-drivers.overrideAttrs (old: {
      version = "4.25.0";
      src = final.fetchFromGitLab {
        group = "tuxedocomputers";
        owner = "development/packages";
        repo = "tuxedo-drivers";
        rev = "v4.25.0";
        hash = "sha256-AER+JPl3lem1OFV51VdOZAnr3Uy1BFSpEJNrE+shYis=";
      };

      # Targets amended: `make` / `$(MAKEFLAGS)` → `$(MAKE)` recursion, which
      # passes the kmodigest `cmd_sign` make-flag safely instead of through
      # the shell. Applied to the `all`, `install` and `clean` targets.
      postPatch = (old.postPatch or "") + ''
        substituteInPlace Makefile \
          --replace-fail 'make -C $(KDIR) M=$(PWD) $(MAKEFLAGS)' '$(MAKE) -C $(KDIR) M=$(PWD)'
      '';

      # Upstream relocated the udev rules from usr/ to files/usr/ in 4.21.0.
      postInstall =
        final.lib.replaceStrings [ "usr/lib/udev" ] [ "files/usr/lib/udev" ]
          (old.postInstall or "")
        # The kernel now ships System.map in kernel.dev, so every external
        # module's `modules_install` runs depmod and writes conflicting
        # modules.* files (NixOS/nixpkgs#576406). Remove those here.
        + ''
          rm -f $out/lib/modules/*/modules.*
        '';
    });
  });
}
