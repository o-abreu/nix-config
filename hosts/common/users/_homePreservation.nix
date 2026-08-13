{
  config,
  inputs,
  lib,
  username,
  persistentPath,
  relativeFlakePath,
  ...
}:
let
  hmConfig = config.home-manager.users.${username};
in
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

    directories =
      with lib;
      [
        relativeFlakePath
        {
          directory = ".ssh";
          mode = "0700";
        }

        # Core User Data (Always preserved)
        "Documents"
        "Music"
        "Pictures"
        "Projects"
        "Templates"
        "Videos"
      ]
      # GPG Keys & Agent
      ++ optionals hmConfig.programs.gpg.enable [
        {
          directory = ".gnupg";
          mode = "0700";
        }
      ]
      # Zoxide Navigation History
      ++ optionals hmConfig.programs.zoxide.enable [
        ".local/share/zoxide"
      ]
      # Neovim Cache, Plugins, and State
      ++ optionals (hmConfig.programs.neovim.enable || hmConfig.programs.nixvim.enable or false) [
        ".local/share/nvim"
        ".local/state/nvim"
        ".cache/nvim"
      ]
      # Other directories
      ++ [
        ".config/libreoffice"
      ];

    files =
      with lib;
      optionals (hmConfig ? sops && hmConfig.sops.age.keyFile != null) [
        {
          file = lib.removePrefix "${hmConfig.home.homeDirectory}/" hmConfig.sops.age.keyFile;
          mode = "0600";
          how = "symlink";
          configureParent = true;
        }
      ]
      # Fish Shell History
      ++ optionals hmConfig.programs.fish.enable [
        ".local/share/fish/fish_history"
      ]
      # Lazygit
      ++ optionals hmConfig.programs.lazygit.enable [
        ".local/state/lazygit/state.yml"
      ];
  };
}
