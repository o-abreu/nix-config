{
  hmConfig,
  persistentPath,
  lib,
  ...
}: let
  inherit (lib) optional optionals;
  prefix = hmConfig.home.homeDirectory + "/";
in {
  preservation.preserveAt.${persistentPath}.users.${hmConfig.home.username} = with hmConfig.programs; {
    directories =
      optional bat.enable ".cache/bat"
      ++ optional fish.enable ".cache/fish"
      ++ optional gpg.enable {
        directory = lib.removePrefix prefix gpg.homedir;
        mode = "0700";
      }
      ++ optional (nixvim.plugins.vim-slime.enable or false) ".local/share/jupyter"
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
        # Asta CLI OAuth token store (tokens.json); survives reboots so the
        # rotating refresh token can auto-refresh. See pkgs/asta.
        {
          directory = ".config/asta-cli";
          mode = "0700";
        }
      ]
      ++ optional qalculate.enable ".local/share/qalculate"
      ++ optional tealdeer.enable ".cache/tealdeer"
      ++ optional thunderbird.enable ".thunderbird"
      ++ optionals wezterm.enable [
        ".local/share/wezterm"
        ".cache/wezterm"
      ]
      ++ optional wfrc.enable wfrc.settings.folder
      ++ optionals zathura.enable [
        ".local/share/zathura"
        ".cache/zathura"
      ]
      ++ optionals (zotero.enable && (zotero.settings ? dataDir)) [
        {
          directory = zotero.settings.dataDir;
          mode = "0700";
        }
        ".zotero/zotero"
      ]
      ++ optional zoxide.enable ".local/share/zoxide";
    files =
      optional lazygit.enable ".local/state/lazygit/state.yml"
      ++ optional qalculate.enable ".config/qalculate/qalc.cnf";
  };
}
