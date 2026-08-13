fileOptionAttrPaths:
{
  config,
  lib,
  ...
}:
{
  config.home.activation.mutableFileGeneration =
    let

      allFiles = (
        builtins.concatLists (
          map (attrPath: builtins.attrValues (lib.getAttrFromPath attrPath config)) fileOptionAttrPaths
        )
      );

      filterMutableFiles = builtins.filter (
        file:
        (file.mutable or false)
        && lib.assertMsg file.force "if you specify `mutable` to `true` on a file, you must also set `force` to `true`"
      );

      mutableFiles = filterMutableFiles allFiles;

      toCommand = (
        file:
        let
          source = lib.escapeShellArg file.source;
          target = lib.escapeShellArg file.target;
        in
        ''
          $VERBOSE_ECHO "${source} -> ${target}"
          $DRY_RUN_CMD cp --remove-destination --no-preserve=mode ${source} ${target}
        ''
      );

      command = ''
        echo "Copying mutable home files for $HOME"
      ''
      + lib.concatLines (map toCommand mutableFiles);

    in
    (lib.hm.dag.entryAfter [ "linkGeneration" ] command);
}
