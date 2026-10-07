# INFO: `zotero-cli` + `zotero-mcp` from github:54yyyu/zotero-mcp (pinned via the
# `zotero-mcp` flake input), built from upstream's pyproject with uv2nix. Upstream
# ships no uv.lock, so one generated against the pinned rev is vendored here
# (regenerate on version bumps -- see TODO.md). The `semantic`, `pdf` and `scite`
# extras are enabled for the `research` agent; see tools/zotero/default.nix.
{
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (inputs) uv2nix pyproject-nix pyproject-build-systems;

  # uv2nix needs uv.lock beside pyproject.toml; overlay the vendored lock and
  # apply cpu-torch.patch so pyproject matches it.
  src = pkgs.runCommand "zotero-mcp-src" {} ''
    cp -r ${inputs.zotero-mcp}/. $out
    chmod -R u+w $out
    cp ${./uv.lock} $out/uv.lock
    # Upstream resolves the default PyPI torch wheel, which drags in ~30
    # nvidia-* CUDA packages. The patch makes torch a direct dependency on the
    # CPU index (matching the vendored lock), keeping the closure sane.
    patch -p1 -d $out < ${./cpu-torch.patch}
  '';

  workspace = uv2nix.lib.workspace.loadWorkspace {workspaceRoot = src;};

  python = lib.head (pyproject-nix.lib.util.filterPythonInterpreters {
    inherit (workspace) requires-python;
    inherit (pkgs) pythonInterpreters;
  });

  pythonSet =
    (pkgs.callPackage pyproject-nix.build.packages {inherit python;})
    |> (base:
      base.overrideScope (lib.composeManyExtensions [
        pyproject-build-systems.overlays.wheel
        (workspace.mkPyprojectOverlay {sourcePreference = "wheel";})
        # bibtexparser 1.4.4 only ships a legacy setup.py sdist; pyproject-nix
        # injects no build system for non-pyproject formats, so add setuptools.
        (final: prev: {
          bibtexparser = prev.bibtexparser.overrideAttrs (old: {
            nativeBuildInputs =
              (old.nativeBuildInputs or [])
              ++ (final.resolveBuildSystem {setuptools = [];});
          });
        })
      ]));

  # `deps.default` omits optional-dependencies; enable the three we want.
  deps =
    workspace.deps.default
    // {"zotero-mcp-server" = ["semantic" "pdf" "scite"];};

  venv = pythonSet.mkVirtualEnv "zotero-mcp-env" deps;
in
  # INFO: Expose only the console scripts, not the whole virtualenv. uv2nix
  # virtualenvs each ship their own `lib/pythonX.Y/site-packages/...` plus
  # generic `bin/` entries (`python`, `httpx`, ...), so two of them in the same
  # profile make `buildEnv` fail with "conflicting subpath" (home-manager's
  # `home-manager-path`, dev shells, ...). The scripts keep working because
  # their shebangs point at the absolute venv path.
  pkgs.runCommand "zotero-mcp" { } ''
    mkdir -p $out/bin
    ${lib.concatMapStringsSep "\n" (
      bin: "ln -s ${venv}/bin/${bin} $out/bin/${bin}"
    ) [
      "zotero-mcp"
      "zotero-mcp-server"
      "zotero-cli"
    ]}
  ''
