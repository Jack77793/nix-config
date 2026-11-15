{ lib, ... }:

{
  services.mpd = {
    enable = true;
    extraConfig = lib.mkMerge [
      (lib.mkBefore ''
        restore_paused "yes"
        auto_update "yes"
        replaygain "track"
        replaygain_preamp "0"
        replaygain_missing_preamp "0"
        filesystem_charset "UTF-8"
      '')
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
    ];
  };

  services.mpd-mpris.enable = true;
}
