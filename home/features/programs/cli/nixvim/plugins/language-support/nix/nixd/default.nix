# INFO: nixd LSP option-scope assembly for the Nix language.
# Encodes the nixd `options` expressions for NixOS and Home-Manager modules.
# Per-input fragments live in ./_entries (see ./_entries.nix for the toggle list).
{
  inputs,
  lib,
  flakePath,
  config,
  ...
}:
let
  # Gather fragments for a given scope ("nixos" | "home-manager") across all entries.
  # field: "attr" (inputs-attrset lines) or "mod" (module list lines)
  mkLines =
    scope: field:
    import ./_entries.nix { inherit inputs lib; }
    |> lib.concatMap (e: e.${scope} or [ ])
    |> map (f: f.${field})
    |> lib.concatLines;

  # Witnesses the `self` input without hardcoding the flake path (used when a
  # module's declaration eval needs `inputs.self`).
  selfExpr = "builtins.getFlake \"${flakePath}\"";
in
{
  programs.nixvim.plugins.lsp.servers.nixd = {
    enable = true;
    settings = {
      nixpkgs.expr = "import ${inputs.nixpkgs} { }";

      options = {
        nixos.expr =
          # nix
          ''
            (let
              pkgs = import ${inputs.nixpkgs} { };
              inputs = {
                nixpkgs = ${inputs.nixpkgs};
                ${mkLines "nixos" "attr"}
                self = ${selfExpr};
              };
            in
            (pkgs.lib.evalModules {
              modules =
                (import ${inputs.nixpkgs}/nixos/modules/module-list.nix)
                ++ [
                  { _module.args = { inherit inputs; }; }
                  ({ ... }: { nixpkgs.hostPlatform = builtins.currentSystem; })
                  ${mkLines "nixos" "mod"}
                ];

            })).options
          '';

        home-manager.expr =
          # nix
          ''
            (let
              pkgs = import ${inputs.nixpkgs} { };
              lib = import ${inputs.home-manager}/modules/lib/stdlib-extended.nix pkgs.lib;
              inputs = {
                nixpkgs = ${inputs.nixpkgs};
                ${mkLines "home-manager" "attr"}
                self = ${selfExpr};
              };
            in
            (lib.evalModules {
              modules =
                (import ${inputs.home-manager}/modules/modules.nix) {
                  inherit lib pkgs;
                  check = false;
                }
                ++ [
                  {
                    _module.args = {
                      inherit inputs;
                      pkgsPath = pkgs.path;
                      homeDirectory = "${config.home.homeDirectory}";
                      username = "${config.home.username}";
                    };
                  }
                  ${mkLines "home-manager" "mod"}
                ];
            })).options
          '';
      };
    };
  };
}
