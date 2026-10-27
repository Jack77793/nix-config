{
  config,
  lib,
  pkgs,
  ...
}:

let
  mpd = config.services.mpd;
  logDirectory = "${config.home.homeDirectory}/Library/Logs/mpd";
in
{
  services.mpd = {
    enable = true;
    musicDirectory = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "${config.home.homeDirectory}/Music";
    extraConfig = lib.mkMerge [
      (lib.mkBefore ''
        restore_paused "yes"
        auto_update "yes"
        replaygain "track"
        replaygain_preamp "0"
        replaygain_missing_preamp "0"
        filesystem_charset "UTF-8"
      '')
      (
        if pkgs.stdenv.hostPlatform.isDarwin then
          ''
            audio_output {
                type "osx"
                name "MPD CoreAudio Output"
                mixer_type "software"
            }
            audio_output {
                type "fifo"
                name "MPD FIFO"
                path "${mpd.dataDir}/ncmpcpp.fifo"
                format "44100:16:2"
            }
          ''
        else
          ''
            audio_output {
                type "pipewire"
                name "MPD PipeWire Output"
            }
            audio_output {
                type "fifo"
                name "MPD FIFO Output"
                path "/tmp/mpd.fifo"
                format "44100:16:2"
            }
          ''
      )
    ];
  };

  home.activation.mpdDirectories = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
    lib.hm.dag.entryBetween [ "linkGeneration" ] [ "writeBoundary" ] ''
      run ${pkgs.coreutils}/bin/mkdir -p ${
        lib.escapeShellArgs [
          mpd.musicDirectory
          mpd.dataDir
          mpd.playlistDirectory
          logDirectory
        ]
      }
    ''
  );
}
