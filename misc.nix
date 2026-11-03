{
  stdenvNoCC,
  fetchgit,
}:
stdenvNoCC.mkDerivation {
  name = "misc";
  version = "0.1.0";
  src = fetchgit {
    url = "https://gitcode.com/Yaoheng2003/awa";
    rev = "4a576bcfc8767c0706865eb6fc56b043c66c9be5";
    hash = "sha256-QOGMzylJ+6Cwnb3110kOclYUhxbBdFGOu51oITTFVzs=";
    fetchLFS = true;
  };
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    tar -zxvf wallpaper.tar.gz
    rm wallpaper.tar.gz
    mv icon/* $out
    rm -rf icon
    mv ./* $out
    runHook postInstall
  '';
}
