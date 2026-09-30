{ inputs, ... }:
final: _prev: {
  unstable = import inputs.nixpkgs {
    system = final.stdenv.hostPlatform.system;
  };
}
