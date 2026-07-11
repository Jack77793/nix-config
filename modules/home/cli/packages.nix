{
  osConfig,
  lib,
  pkgs,
  ...
}:

lib.mkIf osConfig.custom.desktop.enable {
  home.packages = with pkgs; [
    android-tools
    caddy
    cdrtools
    ddcutil
    dig
    dmidecode
    (ffmpeg.override {
      withJxl = true;
      withUnfree = true;
      withVpl = true;
    })
    exiftool
    fio
    tokei
    nmap
    hugo
    imagemagick
    libreoffice-fresh
    libva-utils
    lilypond
    mediainfo
    mpc
    nvme-cli
    nvtopPackages.intel
    playerctl
    pnpm
    qpdf
    scrcpy
    shntool
    vorbis-tools
    wl-clipboard
    winePackages.stagingFull
  ];
}
