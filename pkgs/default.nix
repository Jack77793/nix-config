let
  overlays = [
    (import ./overlays/common.nix)
    (import ./overlays/linux.nix)
  ];
in
{
  inherit overlays;

  packages =
    { nixpkgs, system }:
    let
      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
    in
    {
      inherit (pkgs)
        anthropics-skills
        eisvogel-template
        humanizer
        humanizer-zh
        spotify-adblock
        wechat
        ;
    };
}
