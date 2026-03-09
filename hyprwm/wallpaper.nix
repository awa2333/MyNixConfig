{
  stdenvNoCC,
  fetchgit,
}:
stdenvNoCC.mkDerivation {
  name = "wallpaper";
  version = "0.1.0";
  src = fetchgit {
    url = "https://gitcode.com/Yaoheng2003/awa";
    hash = "sha256-7QtdPXuehR+BVGfth+8EtdEC8/GC1zrx5QJ+gBQhenQ=";
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
