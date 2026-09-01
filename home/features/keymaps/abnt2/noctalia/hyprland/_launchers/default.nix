{
  config,
  lib,
  oneShot,
  prefix,
}:
(import ./applications.nix {
  inherit
    config
    lib
    oneShot
    prefix
    ;
})
++ (import ./noctalia.nix { inherit oneShot prefix; })
