# INFO: JUnit Platform Console Standalone, used by `neotest-java` to run tests.
#
# Upstream, `neotest-java` downloads this jar on demand via `:NeotestJava setup`
# into `stdpath("data")/neotest-java`, verifying it against a hardcoded SHA-256.
# Fetching it here instead makes it content-addressed and cached by Nix, so the
# download happens once per nixpkgs revision rather than once per machine, and the
# jar is only ever read from the immutable store.
#
# The version and hash must stay in sync with `SUPPORTED_VERSIONS` in
# `neotest-java`'s `lua/neotest-java/default_config.lua`. The expected digest for
# 6.0.3 is
#
#     3ba0d6150af79214a1411f9ea2fbef864eef68b68c89a17f672c0b89bff9d3a2
#
# so it is recorded in `sha256` below as the SRI form of that exact value.
#
# INFO: This is frozen, exactly like every other pinned dependency in this config,
# and that is deliberate rather than an oversight. `neotest-java` itself pins two
# versions (`6.0.3` and `1.10.1`) in `SUPPORTED_VERSIONS` and picks the first one;
# 6.0.3 *is* its current latest. So this is not holding anything back that the
# downloader would have picked up on its own — upstream has no auto-update path
# either. Its `:NeotestJava setup` only ever installs one of those two hardcoded
# versions, and its "update available" notice compares your jar against that
# same frozen list. Making the download declarative therefore forfeits nothing:
# the upstream list is hardcoded in a Lua table, so the newest version reachable
# through `:NeotestJava setup` is 6.0.3 today and will only move when the plugin
# is updated.
#
# What this actually buys: reproducibility (no network at editor startup), a jar
# that is content-addressed and shared with every other machine on the nixpkgs
# revision, no `curl`/`sha256sum` subprocess, and no checksum re-verification on
# each run. What it costs: upgrading means bumping `version` and `sha256` here,
# and `nix flake update` will not do it for you — the same contract as every other
# pinned source in this config.
#
# To bump, take the version and digest from `SUPPORTED_VERSIONS` in the
# neotest-java revision this config actually resolves, convert the digest with
# `nix hash convert --hash-algo sha256 --to sri <hex>`, and confirm they agree:
#
#     nix build .#junit-platform-console-standalone
#     sha256sum $(nix build --no-link --print-out-paths \
#       .#junit-platform-console-standalone)/*.jar
{
  lib,
  fetchurl,
  stdenvNoCC,
}:
let
  version = "6.0.3";

  sha256 = "sha256-O6DWFQr3khShQR+eovvvhk7vaLaMiaF/ZywLib/506I=";

  fileName = "junit-platform-console-standalone-${version}.jar";

  src = fetchurl {
    url = "https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/${version}/junit-platform-console-standalone-${version}.jar";
    inherit sha256;
    # The upstream file name has no archive extension, so `fetchurl` would
    # otherwise write `$out` without one. `neotest-java` does not care about the
    # name, but keeping it makes the store path recognisable.
    name = fileName;
  };
in
stdenvNoCC.mkDerivation {
  pname = "junit-platform-console-standalone";
  inherit version;

  inherit src;

  dontUnpack = true;

  # INFO: `neotest-java` passes the jar to `java -jar`, so it only needs to be
  # readable. The store is read-only by construction, so no chmod is needed.
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp ${src} $out/${fileName}

    runHook postInstall
  '';

  # INFO: The jar is read at runtime by the JDK that jdtls reports, not by this
  # derivation, so there is nothing to check here.
  doCheck = false;

  meta = {
    description = "JUnit Platform Console Standalone";
    homepage = "https://junit.org/junit5/";
    license = lib.licenses.epl20;
    platforms = lib.platforms.all;
  };
}