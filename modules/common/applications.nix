{ config, lib, ... }:

lib.mkIf config.custom.desktop.enable {
  home-manager.users.${config.custom.mainUser}.imports = [
    ../home/applications/documents.nix
    ../home/applications/downloads.nix
    ../home/applications/mpv.nix
    ../home/applications/mpd.nix
    ../home/applications/ncmpcpp.nix
  ];
}
