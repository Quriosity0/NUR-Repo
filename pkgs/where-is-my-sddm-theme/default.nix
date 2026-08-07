{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "where-is-my-sddm-theme";
  version = "2fddf8";

  src = fetchFromGitHub {
    owner = "stepanzubkov";
    repo = "where-is-my-sddm-theme";
    rev = "2fddf85ec80ff02a8e20fdcba51a30b436d76e6c";
    hash = "sha256-SNCgpgPyJf9tKE6UyvmEpSJbIfLmAmPazTF85j0W7a0=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/sddm/themes/wims-theme
    cp -r where-is-my-sddm-theme/Main.qml where-is-my-sddm-theme/UsersChoose.qml where-is-my-sddm-theme/SessionsChoose.qml where-is-my-sddm-theme/metadata.desktop where-is-my-sddm-theme/theme.conf where-is-my-sddm-theme/example-configs \
      $out/share/sddm/themes/wims-theme/
  '';

  meta = with lib; {
    description = "The most minimalistic and highly customizable SDDM theme";
    homepage = "https://github.com/stepanzubkov/where-is-my-sddm-theme";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
