let
  overlay = _final: prev: {
    anthropics-skills = prev.callPackage ./anthropics-skills { };
    eisvogel-template = prev.callPackage ./eisvogel-template { };
    humanizer = prev.callPackage ./humanizer { };
    humanizer-zh = prev.callPackage ./humanizer-zh { };
  };
in
{
  overlays = [ overlay ];

  packages =
    { nixpkgs, system }:
    let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    overlay pkgs pkgs;
}
