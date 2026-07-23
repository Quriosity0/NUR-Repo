{ pkgs ? import <nixpkgs> { } }:

let
  pname = "BedrockOnLinux";
  version = "2.0.0";

  src = pkgs.fetchurl {
    url = "https://github.com/Wyze3306/BedrockOnLinux/releases/download/v${version}/BedrockOnLinux-${version}-x86_64.AppImage";
    hash = "sha256-eZepYrU/Mum1Xik20xA7Q/Ir1j34eanEmGdB5BFzHVI=";
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };

  desktopItem = pkgs.makeDesktopItem {
    name = pname;
    exec = "${pname} gui";
    icon = pname;
    desktopName = "BedrockOnLinux";
    genericName = "Minecraft Bedrock Launcher";
    comment = "Run Minecraft Bedrock (Windows GDK) on Linux, multiplayer included";
    categories = [ "Game" "ActionGame" ];
    keywords = [ "minecraft" "bedrock" "gdk" "wine" "proton" "mcbe" ];
    startupNotify = true;
    startupWMClass = "BedrockOnLinux";
  };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${desktopItem}/share/applications/${pname}.desktop \
      $out/share/applications/${pname}.desktop

    install -m 444 -D ${appimageContents}/usr/bin/data/icon.png \
      $out/share/icons/hicolor/256x256/apps/${pname}.png
  '';

  passthru.updateScript = pkgs.nix-update-script { };

  meta = with pkgs.lib; {
    description = "Run Minecraft Bedrock seamlessly on Linux";
    homepage = "https://github.com/Wyze3306/BedrockOnLinux";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
