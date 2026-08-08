{ lib, appimageTools, fetchurl, makeDesktopItem, nix-update-script }:

let
  pname = "OpenNow";
  version = "0.5.3";

  src = fetchurl {
    url = "https://github.com/OpenCloudGaming/OpenNOW/releases/download/v${version}/OpenNOW-v${version}-linux-x86_64.AppImage";
    hash = "sha256-aVbnaUWnhOgAT6wfMQXu8F9/Q5Jx0k6PN9kDKROjvbw=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

  desktopItem = makeDesktopItem {
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${desktopItem}/share/applications/${pname}.desktop \
      $out/share/applications/${pname}.desktop

    install -m 444 -D ${appimageContents}/usr/bin/data/icon.png \
      $out/share/icons/hicolor/256x256/apps/${pname}.png
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Custom GeForce Now Client Named OpenNOW";
    homepage = "https://github.com/OpenCloudGaming/OpenNOW";
    license = licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "opennow";
  };
}
