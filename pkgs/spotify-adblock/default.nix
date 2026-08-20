{ rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
  pname = "spotify-adblock";
  version = "1.1.1";

  src = fetchTarball {
    url = "https://github.com/abba23/${pname}/archive/refs/tags/v${version}/v${version}.tar.gz";
    sha256 = "15xngmbz98i3g142ps1ibvbqqvvdc4m5816y4dvmgk44mzylqp27";
  };
  cargoHash = "sha256-gxGetdqaoJa/ZF1VnW6UXJyJfLBGZxZnyKpT/Qk/8Og=";

  patchPhase = ''
    substituteInPlace src/config.rs \
    --replace '/etc' $out/etc
  '';

  buildPhase = "make";

  installPhase = ''
    mkdir -p $out/etc/spotify-adblock
    install -D --mode=644 config.toml $out/etc/spotify-adblock
    mkdir -p $out/lib
    install -D --mode=644 --strip target/release/libspotifyadblock.so $out/lib
  '';
}
