{
  rustPlatform,
  fetchFromGitHub,
  ...
}:

rustPlatform.buildRustPackage rec {
  pname = "spotify-adblock";
  version = "20260812";
  src = fetchFromGitHub {
    owner = "abba23";
    repo = "spotify-adblock";
    rev = "403b3491cc89d0207c2aa5c349991ba420d97cd1";
    hash = "sha256-R1xM/a+EzFd3I94EVCphbW+M114x6CtIeCOi9Fd9tpc=";
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
