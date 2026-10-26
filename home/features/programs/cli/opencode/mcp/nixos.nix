{ pkgs, lib, ... }:
let
  # INFO: nixpkgs' `fastmcp-slim` 3.4.7 only supports the python `mcp` SDK 1.x
  # and is therefore marked broken while nixpkgs unstable defaults to mcp 2.x
  # (mcp >= 2 renames `McpError` -> `MCPError`, breaking fastmcp-slim's import
  # check). `pkgs.mcp-nixos` scopes its python set to `mcp_1`
  # (`pkgs/by-name/mc/mcp-nixos/package.nix`), but an `overrideScope` on the
  # `mcp` attribute does not re-instantiate `fastmcp`/`fastmcp-slim`, whose
  # closures stay bound to the unscoped mcp 2.x — observed as mcp-2.2.0 in the
  # built environment and the installCheck importing `McpError` failing.
  # Overriding the `mcp` *callPackage argument* of both packages forces the
  # re-instantiation: fastmcp then closes over python3.14-mcp-1.29.0 and the
  # broken predicate evaluates false. Remove this workaround once
  # `pkgs.mcp-nixos` builds on unstable again (see TODO.md under Patches).
  pySet = pkgs.python3Packages.overrideScope (pfinal: pprev: {
    fastmcp-slim = pprev.fastmcp-slim.override { mcp = pfinal.mcp_1; };
    fastmcp = pprev.fastmcp.override { fastmcp-slim = pfinal.fastmcp-slim; };
  });
  mcp-nixos' = pkgs.mcp-nixos.override { python3Packages = pySet; };
in
{
  programs.mcp.servers.nixos.command = lib.getExe mcp-nixos';
}
