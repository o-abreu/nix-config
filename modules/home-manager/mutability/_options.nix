fileOptionAttrPaths: { lib, ... }: {
  options =
    let
      mergeAttrsList = builtins.foldl' (lib.mergeAttrs) { };

      fileAttrsType = lib.types.attrsOf (
        lib.types.submodule (
          { ... }: {
            options.mutable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether to copy the file without the read-only attribute instead of
                symlinking. If you set this to `true`, you must also set `force` to
                `true`. Mutable files are not removed when you remove them from your
                configuration.

                This option is useful for programs that don't have a very good
                support for read-only configurations.
              '';
            };
          }
        )
      );
    in
    mergeAttrsList (
      map (
        attrPath: lib.setAttrByPath attrPath (lib.mkOption { type = fileAttrsType; })
      ) fileOptionAttrPaths
    );
}
