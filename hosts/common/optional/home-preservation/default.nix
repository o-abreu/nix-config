{
  hmConfig,
  inputs,
  lib,
  persistentPath,
  relativeFlakePath,
  ...
}:
with hmConfig.home; {
  imports = [inputs.home-manager.nixosModules.default];

  # Ensure correct permissions when these key directories are generated.
  # NOTE: `systemd.tmpfiles.settings` is three levels deep --
  # `settings.<config-name>.<path>.<tmpfiles-type>` -- so these rules need the
  # `preservation` config-name level. Without it NixOS reads `<path>` as the
  # config name and `.d` as the path, and the eval fails with
  # `settings."<path>".d.group ... is not of type 'submodule'`.
  # This also matches the config name the `preservation` module uses for its
  # own `/persistent/...` rules, so the two sets merge instead of colliding.
  systemd.tmpfiles.settings.preservation = let
    userPerm = mode: {
      user = username;
      group = "users";
      inherit mode;
    };
    parentDirs = [
      ".config"
      ".local"
      ".local/share"
      ".local/state"
    ];
    # The trash spec wants 0700 on the trash dir and its subdirs. Created here
    # so the home trash exists (and is private) before anything uses it.
    trashDirs = [
      ".local/share/Trash"
      ".local/share/Trash/files"
      ".local/share/Trash/info"
    ];
  in
    (map (dir: lib.nameValuePair "${homeDirectory}/${dir}" {d = userPerm "0755";})
      parentDirs)
    ++ (map (dir: lib.nameValuePair "${homeDirectory}/${dir}" {d = userPerm "0700";})
      trashDirs)
    |> builtins.listToAttrs;

  preservation.preserveAt.${persistentPath}.users.${username} = {
    # Hide indicators that the folders listed here are mounted filesystems.
    commonMountOptions = ["x-gvfs-hide"];

    directories =
      [
        relativeFlakePath
        {
          directory = ".ssh";
          mode = "0700";
        }

        "Documents"
        "Music"
        "Pictures"
        "Projects"
        "Public"
        "Templates"
        "Videos"
        # NOTE: Do NOT preserve the trash directory. $HOME is tmpfs while
        # preservation bind-mounts from btrfs, so a preserved trash sits on a
        # different filesystem than the files being trashed. The FreeDesktop spec
        # only allows the home trash for same-filesystem files, so trash-put and
        # yazi's `d` would fall through to `/.Trash-$uid` and fail with EACCES
        # (root is not writable). Each preserved directory above is its own mount
        # point and keeps a persistent `<dir>/.Trash-$uid`, so those stay durable.
      ]
      # Others
      ++ [
        ".config/libreoffice" # Libreoffice does not have a home-manager module yet.
      ];
  };
}
