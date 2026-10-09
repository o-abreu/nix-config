{ lib, ... }: {
  # INFO: Static timezone. Automatic detection (services.automatic-timezoned /
  # GeoClue) was unreliable here: when location lookup failed (e.g. no network
  # at boot) the system stayed on UTC. Pin America/Sao_Paulo instead; use the
  # ASCII IANA name (tzdata does not ship the accented "São_Paulo").
  time.timeZone = "America/Sao_Paulo";
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
