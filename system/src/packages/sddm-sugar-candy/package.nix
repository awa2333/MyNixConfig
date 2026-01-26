{
  lib,
  stdenvNoCC,
  formats,
  libsForQt5,
  themeConfig ? null,
}:
stdenvNoCC.mkDerivation {
  pname = "sddm-sugar-candy";
  version = "1.6";
  src = ./sugar-candy.tar.gz;
  dontWrapQtApps = true;
  buildInputs = [ libsForQt5.qt5.qtgraphicaleffects ];
  installPhase =
    let
      iniFormat = formats.ini { };
      configFile = iniFormat.generate "" { General = themeConfig; };
      basePath = "$out/share/sddm/themes/sugar-candy";
    in
    ''
      mkdir -p ${basePath}
      cp -r ./* ${basePath}
    ''
    + lib.optionalString (themeConfig != null) ''
      ln -sf ${configFile} ${basePath}/theme.conf.user
    '';
}
