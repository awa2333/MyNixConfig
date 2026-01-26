{
  stdenvNoCC,
  buildFHSEnv,
  autoPatchelfHook,
  fontconfig,
  libcxx,
  libice,
}:
let
  pname = "watt-toolkit";
  version = "3.0.0-rc.16";
  src = ./Steampp.tgz;
  watt-toolkit = stdenvNoCC.mkDerivation {
    inherit pname version src;
    nativeBuildInputs = [
      autoPatchelfHook
    ];
    buildInputs = [
      fontconfig
      libcxx
      libice
    ];
    sourceRoot = ".";
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r assemblies $out/lib/watt-toolkit
      cp -r native $out/lib/watt-toolkit
      cp -r modules $out/lib/watt-toolkit/modules
      find $out/lib/watt-toolkit -type f -exec chmod 644 {} \;
      find $out/lib/watt-toolkit/modules -type f -name 'Steam++.*' -exec chmod 755 {} \;
      find $out/lib/watt-toolkit -type f -name '*.dll' -exec strip $STRIP_STATIC {} \;
      find $out/lib/watt-toolkit -type f -name '*.so' -exec strip $STRIP_SHARED {} \;
      install -Dm644 Icons/Watt-Toolkit.png $out/share/watt-toolkit/icons/hicolor/512x512/apps/watt-toolkit.png
      install -Dm755 script/environment_check.sh $out/lib/watt-toolkit/script/environment_check.sh
      runHook postInstall
    '';
  };
in
buildFHSEnv {
  inherit pname version;
  runScript = ''
    dotnet ${watt-toolkit}/lib/watt-toolkit/Steam++.dll "$@"
  '';
  targetPkgs =
    pkgs:
    (with pkgs; [
      fakeNss
      libglvnd
      dbus
      nss_latest
      libGL
      egl-wayland
      libsm
      libice
      fontconfig
      pcre2
      graphite2
      glib
      libgcc
      brotli
      harfbuzz
      libpng
      bzip2
      zlib
      expat
      freetype
      glibc
      libcap
    ])
    ++ (with pkgs.xorg; [
      libX11
      libXcursor
      libSM
      libICE
      libXrandr
      libxcb
      libXext
      libXi
      libXext
      libXfixes
      libXrender
      libXtst
      xrdb
    ])
    ++ (with pkgs.dotnetCorePackages; [
      runtime_9_0
      aspnetcore_9_0
    ]);
}
