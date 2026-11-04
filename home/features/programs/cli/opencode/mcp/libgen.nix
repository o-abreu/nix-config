{
  lib,
  pkgs,
  ...
}: {
  programs = {
    mcp.servers.libgen = {
      command = lib.getExe' pkgs.bun "bunx";
      args = ["-y" "@jmrp.io/libgen-mcp"];
    };
    opencode.settings.permission."libgen_*" = "deny";
  };
}
