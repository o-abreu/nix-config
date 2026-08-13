{
  hmConfig,
  persistentPath,
  username,
  lib,
  ...
}:
{
  preservation.preserveAt.${persistentPath}.users.${username}.directories =
    lib.mkIf (hmConfig.programs.neovim.enable || hmConfig.programs.nixvim.enable or false)
      [
        ".local/share/nvim"
        ".local/state/nvim"
        ".cache/nvim"
      ];
}
