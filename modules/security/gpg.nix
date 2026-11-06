args@{ lib, pkgs, ... }:

{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentry.package = lib.mkMerge [
      (lib.mkDefault (
        if pkgs.stdenv.hostPlatform.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-curses
      ))
      (lib.mkIf (
        pkgs.stdenv.hostPlatform.isLinux && (args.osConfig.custom.desktop.enable or false)
      ) pkgs.pinentry-gnome3)
    ];
  };
}
