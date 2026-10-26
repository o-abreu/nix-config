{ pkgs, lib, ... }:
{
  # INFO: `devenv-mcp` (pkgs/devenv-mcp) execs `devenv mcp` inside a devenv
  # project and otherwise serves an empty MCP server, so OpenCode's
  # "MCP server failed: devenv" toast never fires outside devenv projects.
  programs.mcp.servers.devenv.command = lib.getExe pkgs.devenv-mcp;
}
