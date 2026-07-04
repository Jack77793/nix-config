{ stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "eisvogel-template";
  version = "3.5.1";

  src = fetchTarball {
    url = "https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v${version}/Eisvogel-${version}.tar.gz";
    sha256 = "1f47w7zpnqm60kkmwg3n3vpb64l10ayjfi4c3m047bqm1kicl5xd";
  };

  installPhase = ''
    mkdir -p $out/share/
    cp eisvogel.latex $out/share/
    cp eisvogel.beamer $out/share/
  '';
}
