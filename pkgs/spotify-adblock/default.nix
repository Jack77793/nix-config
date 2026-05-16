{
  rustPlatform,
  fetchFromGitHub,
  ...
}:

rustPlatform.buildRustPackage rec {
  pname = "spotify-adblock";
  version = "20260313";
  src = fetchFromGitHub {
    owner = "abba23";
    repo = "spotify-adblock";
    rev = "813d3451c53126bf1941baaf8dd37f1152c3f412";
    hash = "sha256-nwiX2wCZBKRTNPhmrurWQWISQdxgomdNwcIKG2kSQsE=";
  };
  cargoHash = "sha256-oGpe+kBf6kBboyx/YfbQBt1vvjtXd1n2pOH6FNcbF8M=";

  patchPhase = ''
    substituteInPlace src/lib.rs \
    --replace 'config.toml' $out/etc/spotify-adblock/config.toml
  '';

  buildPhase = "make";

  installPhase = ''
    mkdir -p $out/etc/spotify-adblock
    install -D --mode=644 config.toml $out/etc/spotify-adblock
    mkdir -p $out/lib
    install -D --mode=644 --strip target/release/libspotifyadblock.so $out/lib
  '';
}
