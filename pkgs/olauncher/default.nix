{ pkgs ? import <nixpkgs> { }, temurin-jre-bin-25 }:

let
  icon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Fallen-Breath/classic-minecraft-icon/refs/heads/master/src/main/resources/assets/classicminecrafticon/icons/icon_256x256.png";
    hash = "sha256-QD8p+DpEXkc2MfYNKi0OwbEpilVdayDOXXJthpub7/8=";
  };
in
pkgs.stdenv.mkDerivation rec {
  pname = "olauncher";
  version = "1.7.3_04";

  src = pkgs.fetchurl {
    url = "https://github.com/olauncher/olauncher/releases/download/v${version}/olauncher-${version}-redist.jar";
    hash = "sha256-K3CFG1h9E/EKO0b6mxdHuixO05CjyNXLr90udcDKjL8=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ pkgs.makeWrapper pkgs.copyDesktopItems ];

  runtimeLibs = pkgs.lib.makeLibraryPath [
    pkgs.libGL
    pkgs.libX11
    pkgs.libXext
    pkgs.libXrandr
    pkgs.libXtst
    pkgs.libXi
    pkgs.freetype
    pkgs.glib
    pkgs.alsa-lib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm444 "$src" "$out/share/java/olauncher.jar"

    makeWrapper ${temurin-jre-bin-25}/bin/java $out/bin/olauncher \
      --add-flags "-jar $out/share/java/olauncher.jar" \
      --prefix LD_LIBRARY_PATH : "$runtimeLibs"

    install -Dm444 ${icon} $out/share/icons/hicolor/256x256/apps/olauncher.png

    runHook postInstall
  '';

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "olauncher";
      exec = "olauncher";
      icon = "olauncher";
      desktopName = "OLauncher";
      genericName = "Minecraft Launcher";
      comment = "A modified version of the old Minecraft Launcher";
      categories = [ "Game" ];
    })
  ];

  meta = with pkgs.lib; {
    description = "Modified old-style Minecraft launcher with Microsoft authentication support";
    homepage = "https://github.com/olauncher/olauncher";
    changelog = "https://github.com/olauncher/olauncher/releases/tag/v${version}";
    license = licenses.cc0;
    platforms = platforms.linux;
    mainProgram = "olauncher";
  };
}
