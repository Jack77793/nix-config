[
  (final: prev: {
    anthropics-skills = prev.callPackage ./anthropics-skills { };
    eisvogel-template = prev.callPackage ./eisvogel-template { };
    humanizer = prev.callPackage ./humanizer { };
    humanizer-zh = prev.callPackage ./humanizer-zh { };
    spotify-adblock = prev.callPackage ./spotify-adblock { };
    wechat = prev.callPackage ./wechat { };
  })

  (import ./overlays)
]
