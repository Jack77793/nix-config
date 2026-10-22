{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.custom.desktop.enable {
  home-manager.users.${config.custom.mainUser} = {
    imports = [ ../../home/applications/cava.nix ];

    home.packages = with pkgs; [ soundfont-fluid ];

    programs = {
      mpv = {
        config = {
          hwdec = "vaapi";
          vo = "dmabuf-wayland";
          ytdl-raw-options = "cookies-from-browser=chromium";
        };
        scripts = [ pkgs.mpvScripts.mpris ];
      };

      ncmpcpp.settings.visualizer_data_source = "/tmp/mpd.fifo";

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
        extraConfig = ''
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
  };
}
