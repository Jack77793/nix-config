{
  osConfig,
  lib,
  pkgs,
  ...
}:

lib.mkMerge [
  (lib.mkIf osConfig.custom.desktop.enable {
    home.packages = with pkgs; [
      mesa-demos

      audacity
      bleachbit
      calibre
      davinci-resolve
      file-roller
      foliate
      gimp-with-plugins
      gnome-power-manager
      goldendict-ng
      crosspipe
      localsend
      mediainfo-gui
      meld
      musescore
      qalculate-gtk
      picard
      remmina
      spotify
      telegram-desktop
      qbittorrent-enhanced

      qq
      wechat
      wemeet
    ];
  })

  (lib.mkIf (osConfig.custom.desktop.enable && osConfig.custom.desktop.gui == "gnome") {
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
