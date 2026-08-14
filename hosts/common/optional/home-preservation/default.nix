{
  hmConfig,
  inputs,
  lib,
  username,
  persistentPath,
  relativeFlakePath,
  ...
}:
{

  imports = [ inputs.home-manager.nixosModules.default ];

  # Ensure correct permissions when these key directories are generated
  systemd.tmpfiles.settings.preservation =
    let
      dirs = [
        ".config"
        ".local"
        ".local/share"
        ".local/state"
      ];
      userPerm = {
        user = username;
        group = "users";
        mode = "0755";
      };
    in
    dirs
    |> map (dir: lib.nameValuePair "${hmConfig.home.homeDirectory}/${dir}" { d = userPerm; })
    |> builtins.listToAttrs;

  preservation.preserveAt.${persistentPath}.users.${username} = {

    # Hide indicators that the folders listed here are mounted filesystems.
    commonMountOptions = [ "x-gvfs-hide" ];

    directories = [
      relativeFlakePath
      {
        directory = ".ssh";
        mode = "0700";
      }

      "Documents"
      "Music"
      "Pictures"
      "Projects"
      "Templates"
      "Videos"
      ".local/share/Trash"
    ]
    # Others
    ++ [
      ".config/libreoffice" # Libreoffice does not have a home-manager module yet.
    ];
  };
}
