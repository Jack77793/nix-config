{ stdenvNoCC, fetchurl, ... }:

stdenvNoCC.mkDerivation rec {
  pname = "humanizer";
  version = "20260722";
  src = fetchurl {
    url = "https://raw.githubusercontent.com/blader/humanizer/523374dee72d67c7b2b5f858ea0094ffda49c3ac/SKILL.md";
    hash = "sha256-cJOPPM4llw4d7V/dGUt1XAPx5OT6doIJWM54+Gtnexo=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/humanizer
    cp $src $out/humanizer/SKILL.md
  '';
}
