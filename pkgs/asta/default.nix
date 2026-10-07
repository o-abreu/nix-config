# INFO: `asta` -- CLI from github:allenai/asta-plugins (pinned via the
# `asta-plugins` flake input). Built from the repo's own `uv.lock` with uv2nix,
# so the plugin's `asta-cli` skill finds it on PATH and skips its imperative
# `uv tool install`. Keep the input tag equal to the skills' PLUGIN_VERSION.
{
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (inputs) uv2nix pyproject-nix pyproject-build-systems;

  workspace = uv2nix.lib.workspace.loadWorkspace {
    workspaceRoot = inputs.asta-plugins;
  };

  # Pick an interpreter satisfying `requires-python` from the workspace.
  python =
    pyproject-nix.lib.util.filterPythonInterpreters {
      inherit (workspace) requires-python;
      inherit (pkgs) pythonInterpreters;
    }
    |> lib.head;

  pythonSet =
    (pkgs.callPackage pyproject-nix.build.packages {inherit python;})
    |> (base:
      base.overrideScope (lib.composeManyExtensions [
        pyproject-build-systems.overlays.wheel
        (workspace.mkPyprojectOverlay {sourcePreference = "wheel";})
      ]));
  # `deps.default` includes the workspace member `asta`, so the virtualenv
  # exposes `${venv}/bin/asta` (the `asta.cli:cli` entry point).
  venv = pythonSet.mkVirtualEnv "asta-env" workspace.deps.default;
in
  # INFO: Expose only the console scripts, not the whole virtualenv. uv2nix
  # virtualenvs each ship their own `lib/pythonX.Y/site-packages/...` plus
  # generic `bin/` entries (`python`, `httpx`, ...), so two of them in the same
  # profile make `buildEnv` fail with "conflicting subpath" (home-manager's
  # `home-manager-path`, dev shells, ...). The scripts keep working because
  # their shebangs point at the absolute venv path.
  pkgs.runCommand "asta" {} ''
    mkdir -p $out/bin
    ${lib.concatMapStringsSep "\n" (
        bin: "ln -s ${venv}/bin/${bin} $out/bin/${bin}"
      ) [
        "asta"
        "asta-a2a"
        "asta-agent"
        "asta-artifacts"
      ]}
  ''
