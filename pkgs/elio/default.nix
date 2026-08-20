{lib
, stdenv
, fetchurl
, makeDesktopItem
, makeWrapper
, autoPatchelfHook
, nix-update-script
}:

let
  pname = "elio";
  version = "1.11.2";

  src = fetchurl {
    url = "https://github.com/elio-fm/elio/releases/download/v${version}/elio-${version}-x86_64-unknown-linux-gnu.tar.gz";
    hash = "sha256-R+FJK+3KWuQUL1SiIFWeC+96eE+1MJCPYFnadm0WIi8=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  buildInputs = [
  ];
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/elio
    cp -r ./* $out/opt/elio
  '';
}
