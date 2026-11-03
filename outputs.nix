{
  inputs,
  self,
  moduleWithSystem,
  ...
}:
let
  lib = inputs.nixpkgs.lib;

  experimentalFeatures = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];
in
{
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
    inputs.flake-parts.flakeModules.modules
  ];

  systems = import inputs.systems;

  perSystem = { pkgs, config, ... }: {
    packages = import ./pkgs { inherit pkgs inputs; };

    # INFO: `easyOverlay` derives `flake.overlays.default` from these,
    # replacing `overlays/additions.nix` (which re-imported `../pkgs`
    # wholesale). Each custom package now has a single definition, so
    # `nix build .#<pkg>` and `pkgs.<pkg>` cannot drift apart.
    #
    # NOTE: the generated overlay evaluates these against the overlays applied
    # *before* it, so `hosts/pioneer2/default.nix` applies `default` last.
    overlayAttrs = config.packages;

    devShells = import ./shell.nix { inherit pkgs experimentalFeatures; };
  };

  flake.overlays = import ./overlays { inherit inputs; };

  flake.modules = {
    nixos = import ./modules/nixos { inherit inputs; };

    homeManager =
      import ./modules/home-manager { inherit inputs; }
      // {
        # INFO: `wrappers.lib.wrapPackage` is a flake-scope library, not a
        # per-system attribute. `_module.args` is a single global namespace, so
        # binding it per consumer collides with "defined multiple times while
        # it's expected to be unique"; it is bound here once instead. Import
        # this module alongside opencode, presenterm and wfrc — `home/` does so
        # via `attrValues outputs.modules.homeManager`.
        wrappers = moduleWithSystem (
          _perSystem: {
            _module.args.wrappers = inputs.wrappers.lib;
          }
        );
      };
  };

  # INFO: Plain flake attribute, not a flake-parts option: nixvim owns this
  # namespace, and its `flakeModules.default` rewrites each module's `_file`,
  # which reorders generated plugin setup calls. See TODO.md.
  flake.nixvimModules = import ./modules/nixvim { inherit inputs; };

  flake.nixosConfigurations.pioneer2 = lib.nixosSystem {
    modules = [ ./hosts/pioneer2 ];
    specialArgs = {
      inherit inputs experimentalFeatures;
      outputs = self;
    };
  };
}
