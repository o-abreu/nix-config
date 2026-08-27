{
  dispatch,
  config,
  lib,
  prefix,
}:
let
  exec = cmd: dispatch "exec_cmd('${cmd}')";
in
(import ./applications.nix {
  inherit
    exec
    config
    lib
    prefix
    ;
})
++ (import ./noctalia.nix { inherit exec prefix; })
