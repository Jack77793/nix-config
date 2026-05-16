{ stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "eisvogel-template";
  version = "3.4.0";

  src = fetchTarball {
    url = "https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v${version}/Eisvogel-${version}.tar.gz";
    sha256 = "0cm06sglsxjakcyjh3gscm1f6w6rhpzhxab259pdvigcqm12c7pp";
  };

  installPhase = ''
    mkdir -p $out/share/
    cp eisvogel.latex $out/share/
    cp eisvogel.beamer $out/share/
  '';
}
