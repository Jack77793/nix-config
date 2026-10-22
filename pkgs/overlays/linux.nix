final: prev:

let
  linuxOverlay = prev.lib.composeManyExtensions [
    (_final: prev: {
      spotify-adblock = prev.callPackage ../spotify-adblock { };
      wechat = prev.callPackage ../wechat { };
    })
    (_final: prev: {
      prismlauncher = (import ./prismlauncher) {
        inherit (prev)
          prismlauncher
          glfw
          zulu8
          zulu17
          zulu21
          ;
      };
      spotify = (import ./spotify) {
        inherit (prev)
          spotify
          zip
          unzip
          spotify-adblock
          ;
      };
    })
  ];
in
prev.lib.optionalAttrs prev.stdenv.hostPlatform.isLinux (linuxOverlay final prev)
