final: prev:

let
  linuxOverlay = prev.lib.composeManyExtensions [
    (_final: prev: {
      wechat = prev.callPackage ../wechat { };
    })
    (_final: prev: {
      prismlauncher = (import ./prismlauncher) {
        inherit (prev)
          prismlauncher
          glfw
          zulu17
          zulu21
          ;
      };
    })
  ];
in
prev.lib.optionalAttrs prev.stdenv.hostPlatform.isLinux (linuxOverlay final prev)
