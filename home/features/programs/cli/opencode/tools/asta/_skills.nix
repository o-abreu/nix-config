# INFO: Single source of truth for the vendored Asta skills. Shared by the
# installer (`./asta.nix`) and the `research` agent, which is the only agent
# allowed to load them. `_`-prefixed so import-tree does not auto-import it.
{
  lib,
  inputs,
  plugins,
}: let
  skillsFor = plugin: let
    root = inputs.asta-plugins + "/plugins/${plugin}/skills";
  in
    builtins.readDir root
    |> lib.filterAttrs (_: type: type == "directory")
    |> lib.mapAttrsToList
    (name: _: {
      inherit name;
      path = "${root}/${name}";
    });
in
  lib.concatMap skillsFor plugins
