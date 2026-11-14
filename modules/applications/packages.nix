{
  config,
  lib,
  pkgs,
  _class,
  ...
}:

lib.mkMerge [
  {
    home-manager.users =
      lib.mkIf (_class == "darwin" || (_class == "nixos" && config.custom.desktop.enable))
        {
          ${config.custom.mainUser}.home.packages = lib.sort (a: b: lib.getName a < lib.getName b) (
            with pkgs;
            [
              android-tools
              dig
              exiftool
              (ffmpeg.override (
                {
                  withJxl = true;
                  withUnfree = true;
                }
                // lib.optionalAttrs (_class == "nixos") {
                  withVpl = true;
                }
              ))
              imagemagick
              lilypond
              mediainfo
              nmap
              pnpm
              qpdf
              scrcpy
              shntool
              tokei
              vorbis-tools
            ]
            ++ lib.optionals (_class == "darwin") [
              git
              macmon
              nodejs
              wget
              zulu
            ]
            ++ lib.optionals (_class == "nixos") [
              audacity
              bleachbit
              caddy
              calibre
              cdrtools
              crosspipe
              davinci-resolve
              ddcutil
              dmidecode
              file-roller
              fio
              gimp-with-plugins
              gnome-power-manager
              goldendict-ng
              hugo
              libreoffice
              libva-utils
              localsend
              mediainfo-gui
              meld
              mesa-demos
              moonlight-qt
              mpc
              musescore
              nvme-cli
              nvtopPackages.intel
              picard
              playerctl
              qalculate-gtk
              qbittorrent-enhanced
              qq
              remmina
              spotify
              telegram-desktop
              wechat
              wemeet
              wineWow64Packages.staging
              wl-clipboard
              zotero
            ]
          );
        };
  }
  (lib.optionalAttrs (_class == "darwin") {
    homebrew = {
      enable = true;
      enableZshIntegration = true;
      onActivation.cleanup = "zap";
      casks = [
        "audacity"
        "caffeine"
        "calibre"
        "element"
        "ghostty"
        "gimp"
        "google-chrome"
        "iina"
        "kde-connect"
        "keepassxc"
        "keka"
        "localsend"
        "moonlight"
        "musescore"
        "musicbrainz-picard"
        "neovide-app"
        "obs"
        "prismlauncher"
        "sfm"
        "squirrel-app"
        "telegram-desktop"
        "thunderbird"
        "utm"
        "zotero"
      ];
    };
  })
]
