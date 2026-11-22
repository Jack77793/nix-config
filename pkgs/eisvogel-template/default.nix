{ stdenvNoCC, fetchzip }:

let
  version = "3.5.1";
in
stdenvNoCC.mkDerivation {
  pname = "eisvogel-template";
  inherit version;

  src = fetchzip {
    url = "https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v${version}/Eisvogel-${version}.tar.gz";
    stripRoot = false;
    hash = "sha256-rRfK4gwVr0NAHYxEJ70CgRKz7h52PF7nBKZie//hh7g=";
  };

  installPhase = ''
    mkdir -p $out/share/
    cp eisvogel.latex $out/share/
    cp eisvogel.beamer $out/share/
  '';
}
