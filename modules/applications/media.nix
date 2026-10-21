{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.custom.desktop.enable {
  home-manager.users.${config.custom.mainUser}.imports = [
    ../../home/modules/applications/mpv.nix
    {
      home.packages = with pkgs; [ soundfont-fluid ];

      programs = {
        cava = {
          enable = true;
          settings = {
            color = {
              gradient = 1;
              gradient_color_1 = "'#8FBCBB'";
              gradient_color_2 = "'#88C0D0'";
              gradient_color_3 = "'#81A1C1'";
              gradient_color_4 = "'#5E81AC'";
              gradient_color_5 = "'#B48EAD'";
              gradient_color_6 = "'#EBCB8B'";
              gradient_color_7 = "'#D08770'";
              gradient_color_8 = "'#BF616A'";
            };
            general.framerate = 60;
            output.method = "ncurses";
          };
        };

        mpv = {
          config = {
            hwdec = "vaapi";
            vo = "dmabuf-wayland";
            ytdl-raw-options = "cookies-from-browser=chromium";
          };
          scripts = [ pkgs.mpvScripts.mpris ];
        };

        ncmpcpp = {
          bindings = [
            {
              command = "previous_column";
              key = "h";
            }
            {
              command = "scroll_down";
              key = "j";
            }
            {
              command = "scroll_up";
              key = "k";
            }
            {
              command = "next_column";
              key = "l";
            }
            {
              command = "page_up";
              key = "ctrl-u";
            }
            {
              command = "page_down";
              key = "ctrl-d";
            }
          ];
          enable = true;
          package = pkgs.ncmpcpp.override { visualizerSupport = true; };
          settings = {
            clock_display_seconds = true;
            display_volume_level = true;
            external_editor = "nvim";
            mpd_host = "127.0.0.1";
            mpd_port = 6600;
            use_console_editor = true;
            user_interface = "alternative";
            visualizer_data_source = "/tmp/mpd.fifo";
            visualizer_in_stereo = true;
            visualizer_look = "+|";
            visualizer_output_name = "MPD FIFO";
            visualizer_type = "spectrum";
          };
        };

        obs-studio = {
          enable = true;
          # plugins = with pkgs.obs-studio-plugins; [ wlrobs ];
        };
      };

      services = {
        fluidsynth = {
          enable = true;
          extraOptions = [ "--sample-rate 48000" ];
          soundFont = "${pkgs.soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2";
          soundService = "pipewire-pulse";
        };

        mpd = {
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

        mpd-mpris.enable = true;
      };
    }
  ];
}
