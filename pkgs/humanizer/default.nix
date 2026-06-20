{ stdenvNoCC, fetchurl, ... }:

stdenvNoCC.mkDerivation rec {
  pname = "humanizer";
  version = "20260607";
  src = fetchurl {
    url = "https://raw.githubusercontent.com/blader/humanizer/9600f2b7241cb4eed6ad803abee5ea01d67fe8e4/SKILL.md";
    sha256 = "18za2jhq21hbxxbr2xdvnibgkgw8jxivl7r8zwy4qgm6jvfqbn1d";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/humanizer
    cp $src $out/humanizer/SKILL.md
  '';
}
