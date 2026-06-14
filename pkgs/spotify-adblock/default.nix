{
  rustPlatform,
  fetchFromGitHub,
  ...
}:

rustPlatform.buildRustPackage rec {
  pname = "spotify-adblock";
  version = "20260607";
  src = fetchFromGitHub {
    owner = "abba23";
    repo = "spotify-adblock";
    rev = "9aeadd3cfd4d50212059720c09f662f149942fec";
    hash = "sha256-3X7vScKmnb65wJ4xWAT2AeyAMPTGzKZCFA549zm9gLc=";
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
