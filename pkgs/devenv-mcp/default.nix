# INFO: `devenv-mcp` wraps `devenv mcp` for OpenCode's MCP configuration.
# Outside a devenv project it serves an empty stdio MCP server instead of
# failing, because OpenCode toasts "MCP server failed: <name>" for any server
# that cannot start and offers no per-server way to silence it. The server
# then connects cleanly everywhere and still becomes the real `devenv mcp`
# inside a devenv project. Drop the shim once `devenv mcp` exits quietly
# outside a project or OpenCode can suppress failed-MCP alerts (see TODO.md).
{pkgs, ...}:
pkgs.writeShellApplication {
  name = "devenv-mcp";
  runtimeInputs = [pkgs.devenv pkgs.python3];
  text = ''
    # INFO: Discovery keys on the cwd, not on DEVENV_ROOT. devenv exports
    # DEVENV_ROOT (with DEVENV_PROFILE/STATE/DOTFILE) to every child of an
    # activated shell, and `devenv mcp` reads its project from the cwd rather
    # than from that variable. A long-lived process started in one project --
    # OpenCode opens one MCP connection per session directory -- therefore
    # carries the variable into unrelated directories, where trusting it ran
    # `devenv mcp` in a non-project and exited 1 with "File devenv.nix does not
    # exist", producing OpenCode's "MCP server failed: devenv" toast.
    root=
    dir=$PWD
    while :; do
      for marker in devenv.nix devenv.yaml devenv.yml devenv.lock; do
        if [ -e "$dir/$marker" ]; then
          root=$dir
          break 2
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

    # Keep an activated environment whose markers are absent from the project
    # (a root reached with `devenv --from`), but only when the cwd is really
    # inside it.
    if [ -z "$root" ] && [ -n "''${DEVENV_ROOT:-}" ]; then
      devenv_root=''${DEVENV_ROOT%/}
      case "$PWD" in
        "$devenv_root" | "$devenv_root"/*) root=$devenv_root ;;
      esac
    fi

    # Not a devenv project: stay connected and silent with no tools.
    if [ -z "$root" ]; then
      exec python3 ${./empty-mcp-server.py}
    fi

    # Vars inherited from a different project's shell would make the cwd's
    # project evaluate against the wrong dotfile/state directory and a profile
    # built for someone else. `devenv mcp` rediscovers everything on its own.
    if [ "''${DEVENV_ROOT:-}" != "$root" ]; then
      for name in "''${!DEVENV_@}"; do
        unset "$name"
      done
    fi

    exec devenv mcp "$@"
  '';
}
