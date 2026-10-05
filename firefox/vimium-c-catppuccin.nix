{ stdenvNoCC, fetchFromGitHub }:
stdenvNoCC.mkDerivation rec {
  name = "vimium-catppuccin";
  version = "cec820c38e2e7f589de141edc3459bdf12afb576";
  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "vimium";
    rev = "${version}";
    hash = "sha256-Nuijt4Se3lnUZ/gHC+jAUBbf1KEROT/y2kaOdob/6So=";
  };
  installPhase = ''
    runHook preInstall 
    mkdir -p $out
    cp themes/vimium-c/catppuccin-vimium-c-latte.css $out/latte.css
    runHook postInstall
  '';
}
