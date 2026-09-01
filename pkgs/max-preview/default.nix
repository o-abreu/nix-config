{ lib, stdenvNoCC, yaziPlugins }:
stdenvNoCC.mkDerivation {
  pname = "max-preview";
  version = yaziPlugins.max-preview.version or "unstable-2025-02-18";
  src = yaziPlugins.max-preview;
  postInstall = ''
    substituteInPlace $out/main.lua --replace-fail 'app_emit' 'emit'
  '';
  meta = with lib; {
    description = "Yazi plugin for max preview control (patched for emit compatibility)";
    platforms = platforms.all;
  };
}
