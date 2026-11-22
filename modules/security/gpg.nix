{ pkgs, osConfig, ... }:

{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentry.package =
      if pkgs.stdenv.hostPlatform.isDarwin then
        pkgs.pinentry_mac
      else if osConfig.custom.desktop.enable then
        pkgs.pinentry-gnome3
      else
        pkgs.pinentry-curses;
  };
}
