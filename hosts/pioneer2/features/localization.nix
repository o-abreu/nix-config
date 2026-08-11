{ lib, ... }: {
  time.timeZone = "America/São_Paulo";
  services.xserver.xkb.layout = "br";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings =
      with lib;
      let
        genAttrsRev = flip genAttrs;
      in
      map (str: "LC_${str}") [
        "ADDRESS"
        "IDENTIFICATION"
        "MEASUREMENT"
        "MONETARY"
        "NAME"
        "NUMERIC"
        "PAPER"
        "TELEPHONE"
        "TIME"
      ]
      |> genAttrsRev (_: "pt_BR.UTF-8");
  };

}
