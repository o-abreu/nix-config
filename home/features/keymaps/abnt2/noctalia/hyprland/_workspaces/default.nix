{
  dispatch,
  lib,
  prefix,
}:
let
  count = lib.range 1 10;
  workspaceKey = n: lib.mod n 10 |> toString;
in
(import ./navigation.nix {
  inherit
    dispatch
    prefix
    count
    workspaceKey
    ;
})
++ (import ./move.nix {
  inherit
    dispatch
    prefix
    count
    workspaceKey
    ;
})
++ (import ./send.nix {
  inherit
    dispatch
    prefix
    count
    workspaceKey
    ;
})

