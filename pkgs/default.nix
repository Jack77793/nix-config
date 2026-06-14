{
  packages = {
    eisvogel-template = ./eisvogel-template;
    humanizer = ./humanizer;
    humanizer-zh = ./humanizer-zh;
    spotify-adblock = ./spotify-adblock;
  };

  overlays = [ (final: prev: { wechat = prev.callPackage ./wechat { }; }) ];
}
