{
  osConfig,
  lib,
  pkgs,
  ...
}:

lib.mkIf osConfig.custom.desktop.enable {
  home.packages = with pkgs; [
    android-tools
    libva-utils

    caddy
    cdrtools
    (ffmpeg.override { withUnfree = true; })
    exiftool
    fio
    tokei
    nmap
    hugo
    libreoffice-fresh
    lilypond
    mediainfo
    mpc
    nvme-cli
    nvtopPackages.intel
    playerctl
    qpdf
    scrcpy
    shntool
    vorbis-tools
    wl-clipboard
    winePackages.stagingFull
  ];
}
