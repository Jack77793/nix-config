final: prev:

let
  linuxOverlay = prev.lib.composeManyExtensions [
    (_final: prev: {
      spotify-adblock = prev.callPackage ../spotify-adblock { };
      wechat = prev.callPackage ../wechat { };
    })
    (import ./default.nix)
  ];
in
prev.lib.optionalAttrs prev.stdenv.hostPlatform.isLinux (linuxOverlay final prev)
