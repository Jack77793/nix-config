{
  osConfig,
  lib,
  pkgs,
  ...
}:

lib.mkMerge [
  (lib.mkIf osConfig.custom.desktop.enable {
    home.packages = with pkgs; [
      audacity
      bleachbit
      calibre
      crosspipe
      davinci-resolve
      file-roller
      gimp-with-plugins
      gnome-power-manager
      goldendict-ng
      libreoffice-fresh
      localsend
      mediainfo-gui
      meld
      mesa-demos
      moonlight-qt
      musescore
      picard
      qalculate-gtk
      qbittorrent-enhanced
      remmina
      spotify
      telegram-desktop

      qq
      wechat
      wemeet
    ];
  })

  (lib.mkIf (osConfig.custom.desktop.gui == "gnome") {
    home.packages = with pkgs; [
      citations
      decibels
      endeavour
      fractal
      gnome-calendar
      gnome-characters
      gnome-clocks
      gnome-logs
      gnome-shell-extensions
      gnome-sound-recorder
      gnome-system-monitor
      gnome-weather
      loupe
      newsflash
      resources
      snapshot
      tangram
    ];
  })

  (lib.mkIf osConfig.custom.extras.gaming.enable {
    home.packages = with pkgs; [
      gnome-mines
      gnome-sudoku
      mindustry-wayland
      osu-lazer-bin
    ];
  })
]
