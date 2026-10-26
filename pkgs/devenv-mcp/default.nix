# INFO: `devenv-mcp` wraps `devenv mcp` for OpenCode's MCP configuration.
# Outside a devenv project it serves an empty stdio MCP server instead of
# failing, because OpenCode toasts "MCP server failed: <name>" for any server
# that cannot start and offers no per-server way to silence it. The server
# then connects cleanly everywhere and still becomes the real `devenv mcp`
# inside a devenv project. Drop the shim once `devenv mcp` exits quietly
# outside a project or OpenCode can suppress failed-MCP alerts (see TODO.md).
{
  pkgs,
  ...
}:
pkgs.writeShellApplication {
  name = "devenv-mcp";
  runtimeInputs = [pkgs.devenv pkgs.python3];
  text = ''
    # devenv exports DEVENV_ROOT inside its shell; otherwise mirror devenv's
    # own root discovery (devenv.nix / devenv.yaml in the cwd or any parent).
    if [ -n "''${DEVENV_ROOT:-}" ]; then
      exec devenv mcp "$@"
    fi

    dir=$PWD
    while :; do
      for marker in devenv.nix devenv.yaml devenv.yml devenv.lock; do
        if [ -e "$dir/$marker" ]; then
          exec devenv mcp "$@"
        fi
      done
      if [ "$dir" = "/" ]; then
        break
      fi
      dir=''${dir%/*}
      if [ -z "$dir" ]; then
        dir=/
      fi
    done

    # Not a devenv project: stay connected and silent with no tools.
    exec python3 ${./empty-mcp-server.py}
  '';
}
