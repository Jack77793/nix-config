{ stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation {
  pname = "humanizer-zh";
  version = "20260119";
  src = fetchurl {
    url = "https://raw.githubusercontent.com/op7418/Humanizer-zh/91f3d394db8419c20d67ebe22a96cf8fee0a404b/SKILL.md";
    hash = "sha256-4O29vJAIZEJj1Vc/tZvqyVeU4Yj9mcNQEr/Xnprkvus=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/humanizer-zh
    cp $src $out/humanizer-zh/SKILL.md
  '';
}
