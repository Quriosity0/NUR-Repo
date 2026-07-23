{ pkgs ? import <nixpkgs> { } }:

let
  pname = "leshade";
  version = "2.5.0";

  src = pkgs.fetchurl {
    url = "https://github.com/Ishidawg/LeShade/releases/download/${version}/LeShade-x86_64.AppImage";
    hash = "sha256-TwZAmBO/rgOkXD52Em3qwvt/mrgKleja3NlsW+QJFdk=";
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs': with pkgs'; [
    wineWow64Packages.stable
    winetricks
  ];

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/leshade.desktop \
      $out/share/applications/leshade.desktop
    install -Dm444 ${appimageContents}/leshade.png \
      $out/share/icons/hicolor/256x256/apps/leshade.png
    substituteInPlace $out/share/applications/leshade.desktop \
      --replace 'Exec=LeShade' "Exec=$out/bin/leshade"
  '';

  passthru.updateScript = pkgs.nix-update-script { };

  meta = with pkgs.lib; {
    description = "ReShade manager for Linux (mod-manager style installer for ReShade shaders)";
    homepage = "https://github.com/Ishidawg/LeShade";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "leshade";
  };
}
