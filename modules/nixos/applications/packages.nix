{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.custom.desktop.enable {
  home-manager.users.${config.custom.mainUser} = {
    home.packages = with pkgs; [
      android-tools
      audacity
      bleachbit
      caddy
      calibre
      cdrtools
      crosspipe
      davinci-resolve
      ddcutil
      dig
      dmidecode
      exiftool
      (ffmpeg.override {
        withJxl = true;
        withUnfree = true;
        withVpl = true;
      })
      file-roller
      fio
      gimp-with-plugins
      gnome-power-manager
      goldendict-ng
      hugo
      imagemagick
      libreoffice
      libva-utils
      lilypond
      localsend
      mediainfo
      mediainfo-gui
      meld
      mesa-demos
      moonlight-qt
      mpc
      musescore
      nmap
      nvme-cli
      nvtopPackages.intel
      picard
      playerctl
      pnpm
      qalculate-gtk
      qbittorrent-enhanced
      qpdf
      qq
      remmina
      scrcpy
      shntool
      spotify
      telegram-desktop
      tokei
      vorbis-tools
      wechat
      wemeet
      wineWow64Packages.staging
      wl-clipboard
    ];
  };
}
