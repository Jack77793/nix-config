{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (
      let
        spotify-adblock = rustPlatform.buildRustPackage {
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
        };
      in
      spotify.overrideAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [
          zip
          unzip
        ];
        postInstall = (old.postInstall or "") + ''
          wrapProgram $out/bin/spotify \
          --set LD_PRELOAD "${spotify-adblock}/lib/libspotifyadblock.so" \
          --set XDG_SESSION_TYPE "x11" \
          --set GDK_BACKEND "x11"

          ${unzip}/bin/unzip -p $out/share/spotify/Apps/xpui.spa xpui-snapshot.js | sed 's/adsEnabled:\!0/adsEnabled:false/' > $out/share/spotify/Apps/xpui-snapshot.js
          ${zip}/bin/zip --junk-paths --update $out/share/spotify/Apps/xpui.spa $out/share/spotify/Apps/xpui-snapshot.js
          rm $out/share/spotify/Apps/xpui-snapshot.js
        '';
      })
    )
  ];
}
