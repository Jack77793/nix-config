{
  config,
  lib,
  pkgs,
  _class,
  ...
}:

if _class == "darwin" then
  {
    environment.systemPackages = with pkgs; [
      git
      wget
      android-tools
      dig
      exiftool
      (ffmpeg.override {
        withJxl = true;
        withUnfree = true;
      })
      imagemagick
      lilypond
      mediainfo
      nmap
      nodejs
      pnpm
      qpdf
      scrcpy
      shntool
      tokei
      vorbis-tools
      zulu
      zulu8
      zulu17
    ];

    homebrew = {
      enable = true;
      enableZshIntegration = true;
      onActivation.cleanup = "zap";
      casks = [
        "audacity"
        "caffeine"
        "calibre"
        "ghostty"
        "gimp"
        "google-chrome"
        "keepassxc"
        "localsend"
        "moonlight"
        "obs"
        "prismlauncher"
        "sfm"
        "squirrel-app"
        "telegram-desktop"
        "thunderbird"
        "utm"
      ];
    };
  }
else
  lib.mkIf config.custom.desktop.enable {
    home-manager.users.${config.custom.mainUser}.home.packages = with pkgs; [
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
  }
