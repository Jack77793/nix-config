{ stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "eisvogel-template";
  version = "3.5.0";

  src = fetchTarball {
    url = "https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v${version}/Eisvogel-${version}.tar.gz";
    sha256 = "065b3m7qa1i4jqzcxhnnv3affd7afvvkw586l9kikqxhgxls8mvc";
  };

  installPhase = ''
    mkdir -p $out/share/
    cp eisvogel.latex $out/share/
    cp eisvogel.beamer $out/share/
  '';
}
