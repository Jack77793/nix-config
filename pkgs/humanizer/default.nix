{ stdenvNoCC, fetchurl, ... }:

stdenvNoCC.mkDerivation rec {
  pname = "humanizer";
  version = "20260401";
  src = fetchurl {
    url = "https://raw.githubusercontent.com/blader/humanizer/8b3a17889fbf12bedae20974a3c9f9de746ed754/SKILL.md";
    sha256 = "1s0q7gdafy0gk3875c485acyykx0mvb2wplfhm4zzh49y588nqc5";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/humanizer
    cp $src $out/share/humanizer/SKILL.md
  '';
}
