{ lib, pkgs, ... }: {
  programs.yazi.settings.plugin.append_previewers = [
    {
      url = "*";
      run =
        # bash
        ''faster-piper -- ${lib.getExe pkgs.hexyl} --border=none --terminal-width=$w "$1"'';
    }
  ];
}
