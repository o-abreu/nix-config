# INFO: Workaround. Without it the database was rebuilt every time the session was opened.

{ config, lib, ... }: {
  home = {
    activation.createOpencodeSymlink =
      with config.xdg;
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD mkdir -p $VERBOSE_ARG "${dataHome}"
        $DRY_RUN_CMD ln -sfn $VERBOSE_ARG \
        "${dataHome}/opencode-stable.db" \
        "${dataHome}/opencode.db"
      '';
  };
}
