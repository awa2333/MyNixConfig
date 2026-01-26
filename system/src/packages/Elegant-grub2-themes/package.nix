{
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "Elegant-grub2-themes";
  version = "2025-03-25";
  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    tag = version;
    hash = "sha256-M9k6R/rUvEpBTSnZ2PMv5piV50rGTBrcmPU4gsS7Byg=";
  };
  preInstall = ''
    patchShebangs ./install.sh
    sed -i '193c logoicon="Nixos"' ./install.sh
    sed -i '2s/0/1000/' ./core.sh
    sed -i '8s/\/usr\/share/$out/' ./core.sh
    sed -i 's/\/etc/$out\/etc/g' ./core.sh
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/etc/default
    touch $out/etc/default/grub
    ./install.sh -t wave -p blur -c light -l system
    runHook postInstall
  '';
  postInstall = "rm -rf $out/etc";
}
