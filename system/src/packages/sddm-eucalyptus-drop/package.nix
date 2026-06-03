{
  stdenvNoCC,
  fetchFromGitLab,
  libsForQt5,
  qt6,
}:
stdenvNoCC.mkDerivation rec {
  name = "sddm-eucalyptus-drop";
  version = "2.0.0";
  src = fetchFromGitLab {
    owner = "Matt.Jolly";
    repo = "sddm-eucalyptus-drop";
    tag = "v${version}";
    hash = "sha256-wq6V3UOHteT6CsHyc7+KqclRMgyDXjajcQrX/y+rkA0=";
  };
  buildInputs = [
    libsForQt5.qt5.qtgraphicaleffects
  ];
  nativeBuildInputs = [
    qt6.wrapQtAppsHook
  ];
  qtWrapperArgs = [
    "--prefix PATH : ${libsForQt5.qt5.qtgraphicaleffects}/lib"
  ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/sddm/themes/eucalyptus-drop
    mv ./* $out/share/sddm/themes/eucalyptus-drop
    runHook postInstall
  '';
}
