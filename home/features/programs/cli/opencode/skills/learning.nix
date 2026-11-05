{
  pkgs,
  inputs,
  lib,
  ...
}: let
  sources = with inputs; {
    socratic = neurofoo-agent-skills + "/socratic";
    feynman = neurofoo-agent-skills + "/feynman";
    explaining-code = patricio-skills + "/foundation/explaining-code";
  };

  normalize = import ./_normalize.nix {inherit pkgs;};
in {
  programs.opencode.settings.permission.skill =
    lib.genAttrs (builtins.attrNames sources) (_: "deny");

  xdg.configFile = lib.mapAttrs' (name: src:
    lib.nameValuePair "opencode/skills/${name}" {
      source = normalize {inherit name src;};
    })
  sources;
}
