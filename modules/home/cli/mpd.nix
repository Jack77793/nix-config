{ pkgs, ... }:

{
  services.mpd = {
    enable = true;
    extraConfig = ''
      restore_paused "yes"
      auto_update "yes"
      replaygain "track"
      replaygain_preamp "0"
      replaygain_missing_preamp "0"
      filesystem_charset "UTF-8"
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
    '';
  };

  services.mpd-mpris = {
    enable = true;
    mpd.useLocal = true;
  };

  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override { visualizerSupport = true; };
    bindings = [
      {
        key = "h";
        command = "previous_column";
      }
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "l";
        command = "next_column";
      }
      {
        key = "ctrl-u";
        command = "page_up";
      }
      {
        key = "ctrl-d";
        command = "page_down";
      }
    ];
    settings = {
      mpd_host = "127.0.0.1";
      mpd_port = 6600;
      clock_display_seconds = true;
      display_volume_level = true;
      external_editor = "nvim";
      use_console_editor = true;
      user_interface = "alternative";
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_in_stereo = true;
      visualizer_look = "+|";
      visualizer_output_name = "MPD FIFO";
      visualizer_type = "spectrum";
    };
  };
}
