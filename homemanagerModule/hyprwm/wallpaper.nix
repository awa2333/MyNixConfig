{
  stdenvNoCC,
  fetchgit,
}:
stdenvNoCC.mkDerivation {
  name = "wallpaper";
  version = "0.1.0";
  src = fetchgit {
    url = "https://gitcode.com/Yaoheng2003/awa";
    rev = "08e609a17be3571352c82381a103f2ed64653c50";
    hash = "sha256-ITcTBvrS3h4bvWv2LCwjofB5avRJnz4jfu0EVoR1M6Y=";
    fetchLFS = true;
  };
  installPhase = ''
    runHook preInstall
    tar -zxvf wallpaper.tar.gz
    mkdir -p $out
    cp wallpaper.mp4 $out
    runHook postInstall
  '';
}
