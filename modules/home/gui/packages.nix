{ pkgs, ... }:

{
  home.packages = with pkgs; [
    audacity
    bleachbit
    calibre
    citations
    decibels
    endeavour
    file-roller
    foliate
    fractal
    gimp-with-plugins
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-logs
    gnome-mines
    gnome-power-manager
    gnome-shell-extensions
    gnome-sound-recorder
    gnome-sudoku
    gnome-system-monitor
    gnome-weather
    goldendict-ng
    crosspipe
    localsend
    loupe
    mediainfo-gui
    meld
    musescore
    newsflash
    qalculate-gtk
    picard
    remmina
    resources
    snapshot
    tangram
    telegram-desktop
    qbittorrent-enhanced

    osu-lazer-bin

    qq
    wechat
    wemeet
  ];
}
