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

  # INFO: Prune ephemeral nvim artifacts that accumulate on the persistent volume.
  # - `~/.cache/nvim/luac` grows one directory per nix store path on every nixvim rebuild,
  #   and is never cleaned otherwise. Empty directories (`e`) are pruned after 30 days.
  # - Old log files under `~/.local/state/nvim` (lsp.log, hardtime.nvim.log, ...) are
  #   recreated on demand; undo history and shada are NOT touched.
  systemd.tmpfiles.rules =
    lib.mkIf (hmConfig.programs.neovim.enable || hmConfig.programs.nixvim.enable or false)
      [
        "e %h/.cache/nvim/luac - - - 30d"
        "r %h/.local/state/nvim/*.log - - - 14d"
      ];
}
