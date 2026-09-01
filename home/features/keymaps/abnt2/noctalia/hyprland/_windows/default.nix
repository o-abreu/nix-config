{
  dispatch,
  oneShot,
  prefix,
}:
let
  ccedilla = "code:47";
in
(import ./general.nix { inherit oneShot prefix; })
++ (import ./group.nix { inherit dispatch prefix; })
++ (import ./focus.nix { inherit dispatch prefix ccedilla; })
++ (import ./move.nix { inherit dispatch prefix ccedilla; })
++ (import ./resize.nix { inherit dispatch prefix ccedilla; })
