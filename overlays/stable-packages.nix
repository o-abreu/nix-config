{ inputs, ... }:
final: _prev: {
  # INFO: Package set from `nixos-26.05`, exposed as `pkgs.stable`.
  #
  # Intended for the few packages that do not build on nixpkgs unstable yet, so
  # the system can stay on unstable without holding back everything else. Take
  # the package *wholesale* from here rather than merging single attributes into
  # `pkgs`: a package pinned to an older release usually depends on attributes
  # unstable has since removed, and those would be resolved against unstable and
  # fail to evaluate.
  #
  # Every `pkgs.stable.*` consumer must cite the upstream issue that forces the
  # pin, and must be reverted once that issue is resolved. Current users:
  #   - `zotero` (NixOS/nixpkgs#568692)
  stable = import inputs.nixpkgs-stable {
    system = final.stdenv.hostPlatform.system;
  };
}
