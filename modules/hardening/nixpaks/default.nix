{
  config,
  lib,
  nixpak,
  ...
}:

lib.mkIf config.custom.desktop.enable {
  nixpkgs.overlays = [
    (
      _final: prev:
      let
        mkNixPak = nixpak.lib.nixpak {
          inherit (prev) lib;
          pkgs = prev;
        };
        wrap =
          name: file:
          prev.callPackage file {
            inherit mkNixPak;
            ${name} = prev.${name};
          };
      in
      {
        qq = wrap "qq" ./qq.nix;
        telegram-desktop = wrap "telegram-desktop" ./telegram-desktop.nix;
        wechat = wrap "wechat" ./wechat.nix;
      }
    )
  ];
}
