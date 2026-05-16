{ stdenvNoCC, fetchurl, ... }:

stdenvNoCC.mkDerivation rec {
  pname = "humanizer-zh";
  version = "20260119";
  src = fetchurl {
    url = "https://raw.githubusercontent.com/op7418/Humanizer-zh/91f3d394db8419c20d67ebe22a96cf8fee0a404b/SKILL.md";
    sha256 = "1sxywjd9xmxz298c76gxi3hr8my9xadvagspsmil4r08j2ybvvg0";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/humanizer-zh
    cp $src $out/share/humanizer-zh/SKILL.md
  '';
}
