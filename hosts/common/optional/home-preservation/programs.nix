{
  hmConfig,
  persistentPath,
  lib,
  ...
}: let
  inherit (lib) optional optionals;

  # Zotero's data dir, as set in
  # home/features/programs/gui/office/zotero.nix. `directories` entries are
  # interpreted relative to $HOME, hence the removePrefix.
  zoteroDataDir = lib.removePrefix "${hmConfig.home.homeDirectory}/"
    hmConfig.xdg.userDirs.documents + "/Zotero";
in {
  preservation.preserveAt.${persistentPath}.users.${hmConfig.home.username} = with hmConfig.programs; {
    directories =
      optional bat.enable ".cache/bat"
      ++ optional fish.enable ".cache/fish"
      ++ optional gpg.enable {
        directory = ".gnupg";
        mode = "0700";
      }
      ++ optional (nixvim.plugins.vim-slime.enable or false) ".local/share/jupyter"
      ++ optional lazygit.enable ".local/state/lazygit/state.yml"
      ++ optionals librewolf.enable [
        ".librewolf"
        ".cache/librewolf"
      ]
      ++ optionals (nixvim.enable or false) [
        ".local/share/nvim"
        ".local/state/nvim"
        ".cache/nvim"
      ]
      ++ optional noctalia.enable ".cache/noctalia"
      ++ optional obs-studio.enable ".config/obs-studio"
      ++ optionals opencode.enable [
        ".local/share/opencode"
        ".local/state/opencode"
        ".cache/opencode"
      ]
      ++ optional qalculate.enable ".local/share/qalculate"
      ++ optional tealdeer.enable ".cache/tealdeer"
      ++ optional thunderbird.enable ".thunderbird"
      ++ optionals wezterm.enable [
        ".local/share/wezterm"
        ".cache/wezterm"
      ]
      ++ optionals zathura.enable [
        ".local/share/zathura"
        ".cache/zathura"
      ]
      ++ optional zotero.enable {
        directory = zoteroDataDir;
        mode = "0700";
      }
      ++ optional zoxide.enable ".local/share/zoxide";
    files = optional qalculate.enable ".config/qalculate/qalc.cnf";
  };
}
