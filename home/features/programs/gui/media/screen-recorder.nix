{ pkgs, ... }: {
  programs.wfrc = {
    enable = true;
    recorder = pkgs.wl-screenrec;
    settings = {
      scriptName = "screen-recorder";
      notify = true;
    };
  };
}
